class HallPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    permission_manage_halls?
  end

  def update?
    permission_manage_halls?
  end

  def build_chart?
    create? || update?
  end

  def destroy?
    permission_manage_halls?
  end
end
