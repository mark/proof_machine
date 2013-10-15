gem 'minitest'

require 'proof_machine'

require 'minitest/autorun'
require 'mocha/setup'

class RoiRunner < Struct.new(:roi)

  attr_reader :inference
  
  def premises(*statements)
    statements  = statements.map { |statement| parse(statement) }
    @inference = roi.infer *statements
    self
  end

  def must_infer(statement)
    statement = parse(statement)

    @inference.must_equal(statement)
  end

  def parse(statment)
    if statment.kind_of? String
      parser.parse(clean(statment)).content
    else
      statment
    end
  end

  def clean(string)
    string.tr " \t\r\n", ''
  end

  def parser
    @parser ||= PropositionalCalculusParser.new
  end

end

def runner(rule_of_inference)
  RoiRunner.new(rule_of_inference)
end
