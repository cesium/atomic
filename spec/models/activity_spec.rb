require 'rails_helper'

RSpec.describe activity, type: :model do
  before do
    @activity = FactoryGirl.create :member
  end

  subject { @activity }

  describe "required fields" do

    describe "when name is blank" do
      before { @activity.name = "" }
      it { should_not be_valid }
    end

    describe "when location is blank" do
      before { @activity.location = "" }
      it { should_not be_valid }
    end

    describe "when member_cost is blank" do
      before { @activity.member_cost = nil }
      it { should_not be_valid }
    end

    describe "when guest_cost is blank" do
      before { @activity.guest_cost = nil }
      it { should_not be_valid }
    end

    describe "when start_date is blank" do
      before { @activity.start_date = nil }
      it { should_not be_valid }
    end

    describe "when end_date is blank" do
      before { @activity.end_date = nil }
      it { should_not be_valid }
    end
  end

  describe "parameter limits" do
    describe "when account number is too long" do
      before { @activity.account_number = 'a' * 11 }
      it { should_not be_valid }
    end

    describe "when student id is too long" do
      before { @activity.student_id = 'a' * 11 }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @activity.name = 'a' * 76 }
      it { should_not be_valid }
    end

    describe "when street is too long" do
      before { @activity.street = 'a' * 101 }
      it { should_not be_valid }
    end

    describe "when city is too long" do
      before { @activity.city = 'a' * 31 }
      it { should_not be_valid }
    end

    describe "when phone number is too long" do
      before { @activity.phone_number = '9' * 16 }
      it { should_not be_valid }
    end
  end
end
