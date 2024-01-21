class Hall < ApplicationRecord
  has_many :sessions

  validates :name, :scheme, presence: true
end
