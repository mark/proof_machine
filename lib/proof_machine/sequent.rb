require_relative 'prop'

module ProofMachine

  class Sequent

    ###############
    #             #
    # Constructor #
    #             #
    ###############
    
    def initialize(premises)
      @premises = premises.map { |premise| parse(premise) }
    end

    ####################
    #                  #
    # Instance Methods #
    #                  #
    ####################
    
    def concludes(conclusion)
      @conclusion = parse(conclusion)
    end

    def infer(statements)
      unifier  = Unification.new [@premises, statements]
      bindings = unifier.unify

      bindings && bindings.substitute(@conclusion)
    end

    def parser
      @parser ||= PropositionalCalculusParser.new
    end

    def parse(statement)
      if statement.kind_of?(String)
        parser.parse(statement).content
      else
        statement
      end
    end

  end

end
