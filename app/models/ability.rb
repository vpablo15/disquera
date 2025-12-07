# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # For guest user
    if user.nil?
      return
    end

    can_all_users(user)

    if user.admin?
      can_admin(user)
    elsif user.manager?
      can_manager(user)
    elsif user.employee?
      can_employee(user)
    end

    cannot :change_role, User, id: user.id
  end

  def can_admin(user)
    can :manage, :all
  end

  def can_manager(user)
    can_product
    can :manage, User
    cannot [ :destroy, :delete, :index, :create ], User, role: User
      .roles[:admin]
  end

  def can_employee(user)
    can_product
  end

  def can_product
    can :manage, Album
    can :manage, Author
    can :manage, Genre
    can :manage, Sale
  end


  def can_all_users(user)
    can [ :show, :edit, :update ], User, id: user.id
  end

end
