require 'spec_helper'

include ProofMachine

describe "Modus Ponens" do

  subject { runner(ModusPonens) }

  it "returns B for A => B, A" do
    subject.premises("A => B", "A").must_infer "B"
  end

  it "handles more complicated cases" do
    subject.premises("(A ^ B) => (C => D)", "A ^ B").must_infer "C => D"
  end

  it "works in sequence" do
    result1 = subject.premises("A => B", "A").inference
    subject.premises("B => C", result1).must_infer "C"
  end

end

describe "Modus Tollens" do

  subject { runner(ModusTollens) }

  it "returns ~A for A => B, ~B" do
    subject.premises("A => B", "~B").must_infer "~A"
  end

end

describe "DeMorgans" do

  subject { runner(DeMorgans) }

  it "returns ~A v ~B for ~(A ^ B)" do
    subject.premises('~(A ^ B)').must_infer '~A v ~B'
  end

  it "returns ~(A ^ B) for ~A v ~B" do
    subject.premises('~A v ~B').must_infer '~(A ^ B)'
  end

end

describe "A complete proof" do

  let(:parser) { PropositionalCalculusParser.new }

  let(:premise1) { parser.parse("~A ^ (~B ^ ~C)").content }
  let(:premise2) { parser.parse("(A v B) v D").content }

  it "can handle a complete proof" do
    line3  = LeftConjunctiveSimplification.infer(premise1)
    line4  = Associativity.infer(premise2)
    line5  = DisjunctiveSyllogism.infer(line4, line3)
    line6  = Commutivity.infer(premise1)
    line7  = LeftConjunctiveSimplification.infer(line6)
    line8  = LeftConjunctiveSimplification.infer(line7)
    line9  = DisjunctiveSyllogism.infer(line5, line8)
    line10 = Conjunction.infer(line3, line8)
    line11 = Conjunction.infer(line10, line9)

    line11.must_equal parser.parse("(~A ^ ~B) ^ D").content
  end

end
