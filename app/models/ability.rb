# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # For guest user
    user ||= User.new

    # 1. Permission for all users
    can [:read, :update], User, id: user.id
    cannot :update, User, :role

    # 2. Permissions based on roles
    if user.admin?
      can :manage, :all
    elsif user.manager?
      # Gerente: puede administrar productos y ventas
      # can :manage, Product
      # can :manage, Sale

      # Gerente: puede gestionar (crear/editar/eliminar) usuarios
      can :manage, User
      # Restricción: No puede crear o actualizar usuarios si el rol es 'admin'
      cannot [:create, :update], User do |target_user|
        target_user.admin?
      end

    elsif user.employee?
      # can :manage, Product
      # can :manage, Sale

    end
  end
end
