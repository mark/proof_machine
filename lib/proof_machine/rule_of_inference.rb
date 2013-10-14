module ProofMachine

  class RuleOfInference

    ################
    #              #
    # Declarations #
    #              #
    ################
    
    attr_reader :name

    ###############
    #             #
    # Constructor #
    #             #
    ###############
    
    def initialize(name)
      @name     = name
      @sequents = []
    end

    ####################
    #                  #
    # Instance Methods #
    #                  #
    ####################

    def infer(statements)
      @sequents.map { |seq| seq.infer(statements) }.compact
    end
    
    def premises(*statements)
      Sequent.new(statements).tap do |sequent|
        @sequents << sequent
      end
    end

  end

end
