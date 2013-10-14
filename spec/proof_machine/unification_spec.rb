require 'spec_helper'

include ProofMachine

describe "Unification" do

  it "unifies similar atoms" do
    Unification['abc', 'abc'].must_equal Hash.new
  end
  
  it "doesn't unify different atoms" do
    Unification['abc', 'xyz'].must_be_nil
  end

  it "should unify like symbols" do
    Unification[:x, :x].must_equal Hash.new
  end
  
  it "unifies a variable with an atom" do
    Unification[ :x, 'abc' ].must_equal(x: 'abc')
  end

  it "unifies two variables" do
    Unification[ :x, :y ].must_equal(x: Set[:x, :y], y: Set[:x, :y])
  end

  it "unifies a variable in a function" do
    Unification[ ['f', :x, :y], ['f', :x, 'a'] ].must_equal(y: 'a')
  end

  it "doesn't unify different functions" do
    Unification[ ['f', :x], ['g', :y] ].must_be_nil
  end
  
  it "doesn't unify functions of different arity" do
    Unification[ ['f', :x], ['f', :x, :y] ].must_be_nil
  end

  it "unifies a variable with a function" do
    Unification[ ['f', :x], ['f', ['g', :y]] ].must_equal x: ['g', :y]
  end

  it "simplifies bound components" do
    Unification[ ['f', ['g', :x], :x], ['f', :y, 'a'] ].must_equal x: 'a', y: ['g', 'a']
  end

  it "unifies multiple statements" do
    Unification[:x, :y, :y, 'abc'].must_equal x: 'abc', y: 'abc'
  end
  
  it "should not unify a variable with a function that contains that variable" do
    Unification[ :x, ['f', :x] ].must_be_nil
  end
  
end
