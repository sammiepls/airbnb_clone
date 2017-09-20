class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  def allowed?(action:, user:)
    case
      when action == "verify" && !user.user? then return true
      when action == "edit" && (user.super_admin? || user == current_user) then return true
      else return false
    end

  end
end
