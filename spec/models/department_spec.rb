RSpec.describe Department, type: :model do
  before do
    @department = FactoryGirl.create  :department
  end

  subject { @department }

  describe "required fields" do
    describe "when title is nil" do
      before { @department.title = nil }
      it { should_not be_valid }
    end

    describe "when title is blank" do
      before { @department.title  = ""}
      it { should_not be_valid }
    end
  end

  # Test has_many :roles.
  it "should have many roles" do
    role = FactoryGirl.create  :role
    @department.roles << role

    expect(@department.roles).to eq([role])
  end
end
