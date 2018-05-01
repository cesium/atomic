require "rails_helper"

RSpec.describe User, type: :model do
  describe "validate fields" do
    before { @user = FactoryBot.create :user }

    subject { @user }

    describe "when hashname is blank" do
      before { @user.hashname = "" }
      it { should_not be_valid }
    end

    describe "when email is blank" do
      before { @user.email = "" }
      it { should_not be_valid }
    end

    describe "when name is blank" do
      before { @user.name = "" }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @user.name = "a"*76 }
      it { should_not be_valid }
    end

    describe "when phone_number is too long" do
      before { @user.phone_number = "1"*16 }
      it { should_not be_valid }
    end

    describe "when cesium_id is too long" do
      before { @user.cesium_id = "1"*11 }
      it { should_not be_valid }
    end

    describe "when cesium_id contains letters" do
      before { @user.cesium_id = "a9483219" }
      it { should_not be_valid }
    end

    describe "when student_id is too long" do
      before { @user.student_id = "1"*11 }
      it { should_not be_valid }
    end
  end

  describe "user permissions" do
    it "returns guest when not persistent" do
      user = FactoryBot.build :user

      permissions = user.permissions

      expect(permissions).to eq(:guest)
    end

    it "returns user when persistent" do
      user = FactoryBot.build :user
      user.save

      permissions = user.permissions

      expect(permissions).to eq(:user)
    end

    it "returns activity_admin when admin" do
      user = FactoryBot.build :user
      user.activity_admin = true
      user.save

      permissions = user.permissions

      expect(permissions).to eq(:activity_admin)
    end
  end
end

