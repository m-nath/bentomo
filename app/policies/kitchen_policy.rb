class KitchenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def new?
    user.kitchen.nil?
  end

  def create?
    true
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
