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
    permission_create_and_update_movie?
  end

  def create_with_tmdb?
    permission_create_movie_with_tmdb?
  end

  def update?
    permission_create_and_update_movie?
  end

  def search?
    create?
  end

  def destroy?
    permission_remove_movie?
  end
end
