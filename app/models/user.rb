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
