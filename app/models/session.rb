class Session < ApplicationRecord
  attr_accessor :repeat_to

  belongs_to :movie
  belongs_to :hall

  has_many :tickets

  scope :available, -> { where("start_datetime > ?", Time.now) }

  before_create :build_seats_data
  before_destroy :have_tickets, prepend: true do
    throw(:abort) if errors.present?
  end

  validates :start_datetime, :price, presence: true
  validate :start_datetime_is_future
  validate :hall_available_during_time, on: :create
  validate :have_tickets, on: :update, if: -> { changed.excluding('seats_data').any? }

  def tickets_available?(scheme)
    scheme.each do |row, columns|
      columns.each do |column|
        return false if seats_data[row][column]['booked'] == true
      end
    end

    true
  end

  private

  def build_seats_data
    data = {}
    hall.scheme['seats'].values.each.with_index(1) do |seats, row_index|
      data["row_#{row_index}".to_sym] = {}
      number = 1
      seats.each.with_index(1) do |seat, index|
        if seat
          data["row_#{row_index}".to_sym]["column_#{index}".to_sym] = { booked: false, number: number, space: false }
          number += 1
        else
          data["row_#{row_index}".to_sym]["column_#{index}".to_sym] = { booked: nil, number: nil, space: true }
        end
      end
    end

    self.seats_data = data
  end

  def start_datetime_is_future
    errors.add(:start_datetime, 'must be in the future') if start_datetime <= DateTime.now
  end

  def hall_available_during_time
    conflicting_sessions = Session.available.where(hall_id: hall_id)
                                  .select { |x| start_datetime.between?(x.start_datetime - movie.duration.minutes, x.start_datetime + x.movie.duration.minutes) }
    errors.add(:base, 'The hall is not available during this time') if conflicting_sessions.present?
  end

  def have_tickets
    errors.add(:base, 'The session cannot be updated/canceled after booking the tickets') if tickets.any?
  end
end
