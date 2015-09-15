require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryGirl.create :member
  end

  subject { @user }

  describe "required fields" do
    describe "when account number is blank" do
      before { @user.account_number = "" }
      it { should_not be_valid }
    end

    describe "when student id is blank" do
      before { @user.student_id = "" }
      it { should_not be_valid }
    end

    describe "when name is blank" do
      before { @user.name = "" }
      it { should_not be_valid }
    end

    describe "when street is blank" do
      before { @user.street = "" }
      it { should_not be_valid }
    end

    describe "when city is blank" do
      before { @user.city = "" }
      it { should_not be_valid }
    end

    describe "when phone number is blank" do
      before { @user.phone_number = "" }
      it { should_not be_valid }
    end

    describe "when birthdate is blank" do
      before { @user.birthdate = nil }
      it { should_not be_valid }
    end
  end

  describe "parameter limits" do
    describe "when account number is too long" do
      before { @user.account_number = 'a' * 11 }
      it { should_not be_valid }
    end

    describe "when student id is too long" do
      before { @user.student_id = 'a' * 11 }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @user.name = 'a' * 76 }
      it { should_not be_valid }
    end

    describe "when street is too long" do
      before { @user.street = 'a' * 101 }
      it { should_not be_valid }
    end

    describe "when city is too long" do
      before { @user.city = 'a' * 31 }
      it { should_not be_valid }
    end

    describe "when phone number is too long" do
      before { @user.phone_number = '9' * 16 }
      it { should_not be_valid }
    end
  end
end
