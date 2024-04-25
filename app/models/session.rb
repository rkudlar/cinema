class Session < ApplicationRecord
  attr_accessor :repeat_to

  belongs_to :movie
  belongs_to :hall

  before_create :build_seats_data

  validates :start_datetime, presence: true
  validate :start_datetime_is_future
  validate :hall_available_during_time

  private

  def build_seats_data
    data = {}
    hall.scheme['seats'].values.each.with_index(1) do |seats, row_index|
      data["row_#{row_index}".to_sym] = {}
      seats.each.with_index(1) do |seat, index|
        data["row_#{row_index}".to_sym]["seat_#{index}".to_sym] = seat ? { booked: false, space: false } : { booked: nil, space: true }
      end
    end

    self.seats_data = data
  end

  def start_datetime_is_future
    errors.add(:start_datetime, 'must be in the future') if start_datetime <= DateTime.now
  end

  def hall_available_during_time
    conflicting_sessions = Session.where(hall_id: hall_id)
                                  .select { |x| start_datetime.between?(x.start_datetime - movie.duration.minutes, x.start_datetime + x.movie.duration.minutes) }
    errors.add(:base, 'The hall is not available during this time') if conflicting_sessions.present?
  end
end
