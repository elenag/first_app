class Ability
  include CanCan::Ability

  def initialize(user)
    case user
    when SuperUser
      can :manage, :all
    when AdminUser
      can :create, Customer
      can [:read, :update], Customer, project_id: user.project_id
    end
  end
end
