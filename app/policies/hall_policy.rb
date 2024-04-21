class HallPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    permission_create_hall?
  end

  def update?
    permission_update_hall?
  end

  def build_chart?
    create? || update?
  end

  def destroy?
    permission_destroy_hall?
  end
end
