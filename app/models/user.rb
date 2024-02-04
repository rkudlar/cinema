class User < ApplicationRecord
  PERMISSION_LEVELS = %w(
    manage_halls
    manage_sessions
    manage_movies
    ticket_sales
  )
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: %i[user admin superadmin]
end
