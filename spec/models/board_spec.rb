require 'rails_helper'

RSpec.describe Board, type: :model do
  before do
    @board  = FactoryGirl.create :board
  end

  subject { @board }

  describe "required fields" do
    describe "when year is blank" do
      before { @board.year = nil }
      it { should_not be_valid }
    end

    describe "when year is invalid" do
      before { @board.year = DateTime.now.year + 1 }
      it { should_not be_valid }
    end

    describe "when year is nil" do
      before { @board.year = nil }
      it { should_not be_valid }
    end
  end

  # Test has_many terms.
  it "should have many terms" do
    term    = FactoryGirl.create :term
    user    = FactoryGirl.create :user
    board   = FactoryGirl.create :board
    role    = FactoryGirl.create :role

    term.user   = user
    term.board  = board
    term.role   = role
    @board.terms << term

    expect(@board.terms).to eq([term])
  end
end
