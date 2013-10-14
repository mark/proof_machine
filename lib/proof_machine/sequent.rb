require 'treetop'
require_relative 'prop'

module ProofMachine

  class Sequent

    ###############
    #             #
    # Constructor #
    #             #
    ###############
    
    def initialize(*premises)
      @premises = premises
    end

    ####################
    #                  #
    # Instance Methods #
    #                  #
    ####################
    
    def concludes(conclusion)
      @conclusion = conclusion
    end

    def infer(*statements)
      unifier  = Unification.new [@premises, statements]
      bindings = unifier.unify

      bindings && bindings.substitute(@conclusion)
    end

  end

end
