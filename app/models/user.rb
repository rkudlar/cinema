class User < ApplicationRecord
  PERMISSION_LEVELS = %w[
    create_movie_with_tmdb
    create_and_update_movie
    remove_movie
    create_hall
    update_hall
    destroy_hall
    manage_sessions
    ticket_sales
  ]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[user admin superadmin]
end
