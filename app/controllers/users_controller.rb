class UsersController < Clearance::UsersController
  before_action :require_login, except: [:new, :create]

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      render template: "users/show"
    else
      @errors = @user.errors.full_messages
      render template: "users/new"
    end
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(user_params)
      render template:"users/show"
    else
      @errors = @user.errors.full_messages
      render template: "users/edit"
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  private
  def user_params
    params.require(:user).permit(:first_name,:last_name,:email,:password,:created_at,:updated_at)
  end

end