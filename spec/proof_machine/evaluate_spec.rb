require 'spec_helper'

# describe "Rules of Inference" do

#   premises().must_infer()

# end

def runner(rule_of_inference)
  RoiRunner.new(rule_of_inference)
end

include ProofMachine

describe "Modus Ponens" do

  let(:modus_ponens) do
    RuleOfInference.new("MP").tap do |roi|
      roi.premises([:P, '=>', :Q], :P).concludes(:Q)
    end
  end

  subject { runner(modus_ponens) }

  it "returns B for A => B, A" do
    subject.premises("A => B", "A").must_infer "B"
  end

  it "handles more complicated cases" do
    subject.premises("(A ^ B) => (C => D)", "A ^ B").must_infer "C => D"
  end

  # it "handles nested evaluations" do
  #   modus_ponens.run(
  #     modus_ponens.run('P => (Q => R)', 'P'),
  #     'Q'
  #   ).must_equal 'R'
  # end

end

describe "Modus Tollens" do

  let(:modus_tollens) do
    RuleOfInference.new("MT").tap do |roi|
      roi.premises([:P, '=>', :Q], ['~', :Q]).concludes(['~', :P])
    end
  end

  subject { runner(modus_tollens) }

  it "returns ~A for A => B, ~B" do
    subject.premises("A => B", "~B").must_infer "~A"
  end

end

describe "DeMorgans1" do

  let(:demorgans) do
    RuleOfInference.new("DM").tap do |roi|
      roi.premises(['~', [:P, '^', :Q]]).concludes([['~', :P], 'v', ['~', :Q]])
      roi.premises([['~', :P], 'v', ['~', :Q]]).concludes(['~', [:P, '^', :Q]])
      roi.premises(['~', [:P, 'v', :Q]]).concludes([['~', :P], '^', ['~', :Q]])
      roi.premises([['~', :P], '^', ['~', :Q]]).concludes(['~', [:P, 'v', :Q]])
    end
  end

  subject { runner(demorgans) }

  it "returns ~A v ~B for ~(A ^ B)" do
    subject.premises('~(A ^ B)').must_infer '~A v ~B'
  end

  it "returns ~(A ^ B) for ~A v ~B" do
    subject.premises('~A v ~B').must_infer '~(A ^ B)'
  end

end
