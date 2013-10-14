module ProofMachine

  class Substitution

    ###############
    #             #
    # Constructor #
    #             #
    ###############
    
    def initialize(bindings)
      @bindings = bindings
    end

    ####################
    #                  #
    # Instance Methods #
    #                  #
    ####################
    
    def substitute(term)
      case term
      when Array  then substitute_array(term)
      when Symbol then substitute_variable(term)
                  else term
      end
    end

    private

    def substitute_array(array)
      array.map { |term| substitute term }
    end

    def substitute_variable(variable)
      if @bindings.free?(variable) || @bindings.semifree?(variable)
        variable
      else
        substitute @bindings[variable]
      end
    end

  end

end
