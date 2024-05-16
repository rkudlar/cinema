class UsersController < ApplicationController
  before_action :authenticate_user!

  def tickets
    @tickets = current_user.tickets.includes(session: [:movie, :hall])
  end
end
