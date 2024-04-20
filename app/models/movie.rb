require 'open-uri'

class Movie < ApplicationRecord
  attr_accessor :poster_path

  has_many :sessions
  has_one_attached :poster

  validates :poster, content_type: %i[png jpg jpeg]
  validates :title, :description, :genre, :duration, presence: true
  validates :external_id, uniqueness: true, allow_nil: true

  before_save :remove_empty_value
  before_save :attach_poster, if: -> { poster_path }

  private

  def remove_empty_value
    changes.each_key { |k| send(k).reject!(&:blank?) if send(k).is_a?(Array) }
  end

  def attach_poster
    poster.attach(
      io: URI.open("#{Settings.tmdb.img_url}#{Settings.tmdb.img_path}#{poster_path}"),
      filename: "poster_#{title.parameterize}.jpg"
    )
  end
end
