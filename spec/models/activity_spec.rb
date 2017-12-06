require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe "required fields" do
    before { @activity = FactoryBot.create :activity }

    subject { @activity }

    describe "when name is blank" do
      before { @activity.name = "" }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @activity.name = 'a'*100 }
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

  describe "next activities" do
    before { FactoryBot.create_list(:activity, 20) }

    it "should end in the future" do
      activities = Activity.next_activities
      expect(activities.none?(&:already_happened?)).to be true
    end

    it "should be sorted by nearest date first" do
      activities = Activity.next_activities
      sorted_activities = activities.sort_by(&:end_date)

      expect(activities).to eq(sorted_activities)
    end
  end

  describe "previous activities" do
    before { FactoryBot.create_list(:activity, 20) }

    it "should end in the past" do
      activities = Activity.previous_activities
      expect(activities.all?(&:already_happened?)).to be true
    end

    it "should sorted by nearest date first" do
      activities = Activity.previous_activities
      sorted_activities = activities.sort_by(&:end_date).reverse!

      expect(activities).to eq(sorted_activities)
    end
  end
end
