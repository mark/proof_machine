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

      yield(self) if block_given?
    end

    ####################
    #                  #
    # Instance Methods #
    #                  #
    ####################

    def infer(*statements)
      @sequents.map { |seq| seq.infer(statements) }.compact.first
    end
    
    def premises(*statements)
      Sequent.new(statements).tap do |sequent|
        @sequents << sequent
      end
    end

    def premise(statement)
      premises(statement)
    end

    def equates(statement1, statement2)
      premise(statement1).concludes(statement2)
      premise(statement2).concludes(statement1)
    end

  end

end
