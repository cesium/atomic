require 'rails_helper'

RSpec.describe Role, type: :model do
  before do
    @role = FactoryGirl.create :role
  end

  describe "required fields" do
    describe "when title is empty" do
      before { @role.title = "" }
      it { should_not be_valid }
    end

    describe "when title is nil" do
      before { @role.title = nil }
      it { should_not be_valid }
    end

    describe "when department is nil" do
      before { @role.department = nil }
      it { should_not be_valid }
    end
  end
end
