class MoviePolicy < ApplicationPolicy
  def index?
    allowed?
  end

  def new?
    allowed?
  end

  def edit?
    permission_create_and_update_movie?
  end

  def create?
    permission_create_and_update_movie?
  end

  def create_with_tmdb?
    permission_create_movie_with_tmdb?
  end

  def update?
    permission_create_and_update_movie?
  end

  def search?
    allowed?
  end

  def destroy?
    permission_remove_movie?
  end

  private

  def allowed?
    @user.admin? || @user.superadmin?
  end
end
