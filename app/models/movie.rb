class Movie < ApplicationRecord
  has_many :sessions

  validates :title, :description, :genre, :duration, presence: true
end
