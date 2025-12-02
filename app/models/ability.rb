# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # For guest user
    user ||= User.new

    can_all_users(user)

    if user.admin?
      can_admin(user)
    elsif user.manager?
      can_manager(user)
    elsif user.employee?
      can_employee(user)
    end
  end

  def can_admin(user)
    can :manage, :all
  end
  def can_manager(user)
    # can :manage, Product
    # can :manage, Sale
    can [:destroy, :delete, :index], User, role: User.roles.values - [User
      .roles[:admin]]


  end

  def can_employee(user)
    # Empleado: puede ver productos y ventas
    # can :read, Product
    # can :read, Sale
  end

  def can_all_users(user)
    can [ :show, :update ], User, id: user.id
    cannot :update, User, :role
  end
end
