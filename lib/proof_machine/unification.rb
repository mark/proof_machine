require_relative 'bindings'

module ProofMachine

  class Unification

    attr_reader :statements

    ###############
    #             #
    # Constructor #
    #             #
    ###############
    
    def initialize(statements)
      @statements = statements
    end

    #################
    #               #
    # Class Methods #
    #               #
    #################
    
    def self.[](*statements)
      result = new(statements).unify
      result ? result.to_hash : result
    end

    ####################
    #                  #
    # Instance Methods #
    #                  #
    ####################
    
    def unify
      catch(:unification_failed) do
        Bindings.new.tap do |bindings|
          (statements.length - 1).times do |idx|
            unify_terms bindings, statements[idx], statements[idx+1]
          end
        end
      end
    end

    private

    # Arrays

    def unify_array(bindings, array, other)
      case other
      when Symbol then bindings[other] = array
      when Array  then unify_array_with_array(bindings, other, array)
                  else throw :unification_failed
      end
    end

    def unify_array_with_array(bindings, array_1, array_2)
      throw :unification_failed unless array_1.length == array_2.length

      array_1.zip(array_2).each do |item_1, item_2|
        unify_terms(bindings, item_1, item_2)
      end
    end

    # Atoms

    def unify_atoms(bindings, term, other)
      if other.kind_of? Symbol
        bindings[other] = term
      elsif term != other
        throw :unification_failed
      end
    end

    # Terms

    def unify_terms(bindings, item_1, item_2)
      case item_1
      when Symbol then bindings[item_1] = item_2
      when Array  then unify_array(bindings, item_1, item_2)
                  else unify_atoms(bindings, item_1, item_2)
      end
    end

  end

end
