gem 'minitest'

require 'proof_machine'

require 'minitest/autorun'
require 'mocha/setup'

class RoiRunner < Struct.new(:roi)

  def premises(*statements)
    statements  = statements.map { |statement| parse(statement) }
    @inferences = roi.infer statements
    self
  end

  def must_infer(statement)
    statement = parse(statement)

    @inferences.must_include(statement)
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
