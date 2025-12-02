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

    can :manage, User
    cannot :update, User, [:role]
    cannot :create, User

    # Restricción: No puede crear o actualizar usuarios si el rol es 'admin'
    cannot [ :update ], User do |target_user| target_user.admin?
    end
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
