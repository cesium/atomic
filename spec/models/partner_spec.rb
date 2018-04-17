require "rails_helper"

RSpec.describe Partner, type: :model do
  describe "required fields" do
    before { @partner = FactoryBot.create :partner }

    subject { @partner }

    describe "when name is blank" do
      before { @partner.name = "" }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @partner.name = "a" * 100 }
      it { should_not be_valid }
    end

    describe "when description is blank" do
      before { @partner.description = "" }
      it { should_not be_valid }
    end
  end
end
