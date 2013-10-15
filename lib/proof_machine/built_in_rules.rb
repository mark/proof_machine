module ProofMachine

  ModusPonens = RuleOfInference.new("MP") do |roi|
    roi.premises(":P => :Q", ":P").concludes(":Q")
  end

  ModusTollens = RuleOfInference.new("MT") do |roi|
    roi.premises(":P => :Q", "~:Q").concludes("~:P")
  end

  DeMorgans = RuleOfInference.new("DM") do |roi|
    roi.equates "~(:P ^ :Q)", "~:P v ~:Q"
    roi.equates "~(:P v :Q)", "~:P ^ ~:Q"
  end

  DoubleNegation = RuleOfInference.new("DN") do |roi|
    roi.equates ":P", "~~:P"
  end

  Commutivity = RuleOfInference.new("Com") do |roi|
    roi.equates ":P ^ :Q", ":Q ^ :P"
    roi.equates ":P v :Q", ":Q v :P"
  end

  Associativity = RuleOfInference.new("Assoc") do |roi|
    roi.equates ":P ^ (:Q ^ :R)", "(:P ^ :Q) ^ :R"
    roi.equates ":P v (:Q v :R)", "(:P v :Q) v :R"
  end

  Conjunction = RuleOfInference.new("Conj") do |roi|
    roi.premises(":P", ":Q").concludes ":P ^ :Q"
  end

  LeftConjunctiveSimplification = RuleOfInference.new("LCS") do |roi|
    roi.premise(":P ^ :Q").concludes ":P"
  end

  RightConjunctiveSimplification = RuleOfInference.new("RCS") do |roi|
    roi.premise(":P ^ :Q").concludes ":Q"
  end

  DisjunctiveSyllogism = RuleOfInference.new("DS") do |roi|
    roi.premises(":P v :Q", "~:P").concludes ":Q"
    roi.premises(":P v :Q", "~:Q").concludes ":P"
  end

  HypotheticalSyllogism = RuleOfInference.new("HS") do |roi|
    roi.premises(":P => :Q", ":Q => :R").concludes ":P => :R"
  end

  Contraposition = RuleOfInference.new("Contra") do |roi|
    roi.equates ":P => :Q", "~:Q => ~:P"
  end

  ConstructiveDilemma = RuleOfInference.new("CD") do |roi|
    roi.premises(":P v :Q", ":P => :R").concludes ":R v :Q"
    roi.premises(":P v :Q", ":Q => :R").concludes ":P v :R"
  end

end