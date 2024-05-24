class User < ApplicationRecord
  PERMISSION_LEVELS = %w[
    manage_movies
    manage_halls
    manage_sessions
    ticket_sales
  ]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tickets

  enum role: %i[user admin superadmin]

  def stripe_customer
    stripe_customer_id ? Stripe::Customer.retrieve(stripe_customer_id) : create_stripe_customer
  end

  private

  def create_stripe_customer
    stripe_customer = Stripe::Customer.create(email: email)
    update(stripe_customer_id: stripe_customer.id)
    stripe_customer
  end
end
