require "rails_helper"

RSpec.describe Job, type: :model do
  describe "required fields" do
    before { @job = FactoryBot.create :job }

    subject { @job }

    describe "when position is blank" do
      before { @job.position = "" }
      it { should_not be_valid }
    end

    describe "when location is blank" do
      before { @job.location = "" }
      it { should_not be_valid }
    end

    describe "when link is blank" do
      before { @job.link = "" }
      it { should_not be_valid }
    end
  end
end
