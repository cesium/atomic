class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    case user.permissions
    when :guest then guest_permissions(user)
    when :user then user_permissions(user)
    when :activity_admin then activity_admin_permissions(user)
    end
  end

  private

  def guest_permissions(user)
    can :read, Activity
    can :read, Job
    can :destroy, :session if user.persisted?
    can %i[read create], :session unless user.persisted?
    can :index, Partner
  end

  def user_permissions(user)
    guest_permissions(user)
    can :destroy, Registration
    can :create, Registration, activity: { allows_registrations: true }
  end

  def activity_admin_permissions(user)
    user_permissions(user)
    can :manage, Activity
    can :manage, Job
    can %i[index update], Registration
    can :manage, Partner
  end
end
