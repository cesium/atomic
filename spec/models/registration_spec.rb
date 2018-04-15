require "rails_helper"

RSpec.describe "Registration", type: :model do
  describe "toggle_confirmation" do
    context "when old_value casts to true" do
      it "assigns confirmed to false" do
        registration = create(:registration)

        registration.toggle_confirmation("true")

        expect(registration.reload.confirmed).to eq(false)
      end

      it "returns the correct values" do
        registration = create(:registration)

        msg_type, msg = registration.toggle_confirmation("true")

        expect(msg_type).to eq(:alert)
        expect(msg).to eq("Confirmação de #{registration.user.name} cancelada!")
      end
    end

    context "when old_value casts to false" do
      it "assigns confirmed to true" do
        registration = create(:registration)

        registration.toggle_confirmation("false")

        expect(registration.reload.confirmed).to eq(true)
      end

      it "returns the correct values" do
        registration = create(:registration)

        msg_type, msg = registration.toggle_confirmation("false")

        expect(msg_type).to eq(:success)
        expect(msg).to eq("#{registration.user.name} confirmado!")
      end
    end
  end
end
