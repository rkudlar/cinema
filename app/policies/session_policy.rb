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

  def tickets?
    permission_ticket_sales?
  end

  def book?
    permission_ticket_sales?
  end
end
