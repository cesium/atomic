require "rails_helper"

RSpec.describe Payment, type: :model do
  before do
    @user = FactoryBot.create :member
    @payment = Payment.new(date: Time.now, value: 7.50, user_id: @user.id)
    @new_payment = Payment.new(date: Time.now, value: 10.00)
  end

  subject { @payment }

  describe "required fields" do
    describe "when no date is specified" do
      before { @payment.date = nil }
      it { should_not be_valid }
    end

    describe "when no value is specified" do
      before { @payment.value = nil }
      it { should_not be_valid }
    end
  end

  describe "field limits" do
    describe "when value is set to zero" do
      before { @payment.value = 0 }
      it { should_not be_valid }
    end

    describe "when value is less than zero" do
      before { @payment.value = -1.0 }
      it { should_not be_valid }
    end

    describe "when value is positive" do
      before { @payment.value = 1 }
      it { should be_valid }
    end
  end
end
