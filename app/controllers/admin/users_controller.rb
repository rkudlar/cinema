module Admin
  class UsersController < Admin::BaseController
    before_action -> { authorize(:user) }
    before_action :load_users

    def index; end

    def update
      if params[:commit] == t('admin.users.actions.downgrade')
        user.update(role: :user, permissions: [])
        flash.now[:success] = "#{user.email} has been downgraded to user!"
      else
        user.update(params[:user].present? ? user_params : { permissions: [] })
          params[:commit] == t('admin.users.actions.update') ? "Permissions for #{user.email} updated!" :
                                                               "#{user.email} has been added to the team!"
      end
      @user = User.new
      render :index, status: :see_other
    end

    def add
      if user.present?
        if user.user?
          user.update(user_params)
          flash.now[:success] = "#{params[:user][:email]} has been added to the team!"
        else
          flash.now[:danger] = "User with this email already admin!"
        end
        @user = User.new
      else
        flash.now[:danger] = "User with this email does not exist"
      end
      render :index, status: :see_other
    end

    private

    def user
      @user ||= params[:id] ? User.find(params[:id]) : User.find_by(email: params[:user][:email])
    end

    def load_users
      @users = User.where.not(role: :user)
    end

    def user_params
      params.require(:user).permit(:role, permissions: [])
    end
  end
end
