class UserPolicy < ApplicationPolicy
  def index?
    allowed?
  end

  def add?
    allowed?
  end

  def update?
    allowed?
  end

  private

  def allowed?
    @user.superadmin?
  end
end
