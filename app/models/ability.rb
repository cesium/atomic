class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    case user.permissions
    when :guest
      can :read, Activity
    when :user
      can :read, Activity
      can [:create, :destroy], Registration
    when :activity_admin
      can :manage, [Activity, Registration]
    end
  end
end
