class Hall < ApplicationRecord
  has_many :sessions, dependent: :nullify

  validates :name, :scheme, presence: true

  before_destroy :have_scheduled_session, prepend: true do
    throw(:abort) if errors.present?
  end

  private

  def have_scheduled_session
    errors.add(:base, 'The hall cannot be deleted when there are scheduled sessions') if sessions.available.any?
  end
end
