class SessionsController < Clearance::SessionsController
  def new
    @user = User.new
    render template: "sessions/new"
  end

  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        flash[:failure] = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end
end
