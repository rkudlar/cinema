class SessionPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    permission_manage_sessions?
  end

  def update?
    permission_manage_sessions?
  end

  def destroy?
    permission_manage_sessions?
  end
end
