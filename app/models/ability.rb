class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.activity_admin?
      can :manage, [Activity, Registration]
    else
      can :read, Activity
      can [:create, :destroy], Registration
    end
  end

end
