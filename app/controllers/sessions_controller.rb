class SessionsController < Clearance::SessionsController
  def new
    @user = User.new
    render template: "sessions/new"
  end

  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        flash[:success] = "You have successfully logged in"
        redirect_back_or url_after_create
      else
        flash[:failure] = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end

  # Facebook
  def create_from_omniauth
    # whatever you request from fb is stored in auth_hash
     auth_hash = request.env["omniauth.auth"]
    #  You have two tables in your db. one is user, one is authentication
    # When you login to fb, you need to know your user is from where and that its not a new user
    # This means go to your authentication table and find the user by this hash
     authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) ||  Authentication.create_with_omniauth(auth_hash) #this creates new authentication if it can't find it

     # if: previously already logged in with OAuth
     if authentication.user #you will get the user that has signed up before
       user = authentication.user
       authentication.update_token(auth_hash)
       @next = root_url
       flash[:success] = "Signed in!"
     # else: user logs in with OAuth for the first time
     else
       user = User.create_with_auth_and_hash(authentication, auth_hash)
       # you are expected to have a path that leads to a page for editing user details
       @next = edit_user_path(user) #redirects to user to edit their user details
       flash[:success] = "User created. Please confirm or edit details"
     end

     sign_in(user)
     redirect_to @next, :notice => @notice
   end
end

# If its the users first time signing in, i will create an authentication and a user object for him. If i have signed in before, i WIll sign him in and redirect to root page.
