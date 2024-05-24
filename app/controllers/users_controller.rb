class UsersController < ApplicationController
  before_action :authenticate_user!

  def tickets
    @tickets = current_user.tickets.includes(session: [:movie, :hall]).where(session_id: Session.available.pluck(:id))
  end
end
