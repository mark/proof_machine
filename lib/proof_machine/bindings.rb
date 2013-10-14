require 'set'

module ProofMachine

  class Bindings

    ################
    #              #
    # Declarations #
    #              #
    ################
    
    attr_reader :bindings

    ###############
    #             #
    # Constructor #
    #             #
    ###############
    
    def initialize
      @bindings     = Hash.new { |hash, variable| hash[variable] = Set.new([variable]) }
      @substitution = Substitution.new(self)
    end

    ####################
    #                  #
    # Instance Methods #
    #                  #
    ####################
    
    def [](variable)
      @bindings[variable]
    end

    def []=(variable, term)
      return if variable == term

      if term.kind_of? Symbol
        merge variable, term
      elsif semifree?(variable)
        assign self[variable], term
      else
        throw :unification_failed unless term == self[variable]
      end
    end

    def bound?(variable)
      ! free?(variable) && ! semifree?(variable)
    end

    def free?(variable)
      ! @bindings.has_key?(variable)
    end

    def semifree?(variable)
      @bindings[variable].kind_of? Set
    end

    def substitute(term)
      @substitution.substitute(term)
    end
    
    def to_hash
      @bindings.dup
    end

    private

    def assign(variables, term)
      variables.each do |variable|
        throw :unification_failed if occurs?(variable, term)

        @bindings[variable] = term
      end

      simplify!
    end

    def merge(variable_1, variable_2)
      value_1, value_2 = self[variable_1], self[variable_2]
      return if value_1 == value_2

      if semifree?(variable_1) && semifree?(variable_2)
        new_set = value_1 | value_2
        assign new_set, new_set
      elsif semifree?(variable_1)
        assign value_1, value_2
      elsif semifree?(variable_2)
        assign value_2, value_1
      else
        throw :unification_failed
      end
    end

    def simplify!
      @bindings.each do |variable, term|
        @bindings[variable] = substitute(term)
      end
    end

    def occurs?(variable, term)
      return true if term == variable
      return false unless term.kind_of? Array
      
      term.any? { |inside| occurs? variable, inside }
    end

  end

end
