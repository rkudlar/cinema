class Session < ApplicationRecord
  belongs_to :movie
  belongs_to :hall

  validates :start_datetime, presence: true
  validate :hall_available_during_time

  private

  def hall_available_during_time
    conflicting_sessions = Session.where(hall_id: hall_id)
                                  .select { |x| start_datetime.between?(x.start_datetime, x.start_datetime + x.movie.duration.minutes) }
    errors.add(:base, 'The hall is not available during this time') if conflicting_sessions.present?
  end
end
