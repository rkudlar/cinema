module Admin
  class BaseController < ApplicationController
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_action :authenticate_user!
    after_action :verify_authorized

    layout 'admin'

    private

    def user_not_authorized
      flash[:danger] = 'You are not authorized to perform this action.'
      redirect_to(request.referer || root_path)
    end
  end
end
