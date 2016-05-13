class ApplicationController < ActionController::Base #JSONAPI::ResourceController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include DeviseTokenAuth::Concerns::SetUserByToken

  private

  def admin_only
    unless current_user.admin?
      render status: :forbidden, json: { message: 'Access denied' }
    end
  end
end
