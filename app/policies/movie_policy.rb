class MoviePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def create?
    permission_manage_movies?
  end

  def create_with_tmdb?
    permission_manage_movies?
  end

  def update?
    permission_manage_movies?
  end

  def search?
    create?
  end

  def destroy?
    permission_manage_movies?
  end
end
