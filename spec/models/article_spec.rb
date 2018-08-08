require "rails_helper"

RSpec.describe Article, type: :model do
  describe "required fields" do
    before { @article = FactoryBot.create :article }

    subject { @article }

    describe "when name is blank" do
      before { @article.name = "" }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @article.name = "a" * 100 }
      it { should_not be_valid }
    end
  end
end
