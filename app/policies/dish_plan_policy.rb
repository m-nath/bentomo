class DishPlanPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.plan.kitchen.user == user
  end

  def destroy?
    create?
  end
end
