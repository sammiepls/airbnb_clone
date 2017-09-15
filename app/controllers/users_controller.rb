class UsersController < Clearance::UsersController

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      render template: "users/show"
    else
      render template: "users/new"
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name,:last_name,:email,:password)
  end

end
