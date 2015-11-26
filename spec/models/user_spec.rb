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

    describe "when phone number is blank" do
      before { @user.phone_number = "" }
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

    describe "when city is too long" do
      before { @user.city = 'a' * 31 }
      it { should_not be_valid }
    end

    describe "when phone number is too long" do
      before { @user.phone_number = '9' * 16 }
      it { should_not be_valid }
    end
  end

  describe "parameter validations" do
    describe "with letters in phone number" do
      before { @user.phone_number = 'aaa' }
      it { should_not be_valid }
    end

    describe "with letters in account number" do
      before { @user.account_number = 'aaa' }
      it { should_not be_valid }
    end
  end
end
