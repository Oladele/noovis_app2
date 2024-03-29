class ApiController < JSONAPI::ResourceController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  before_action :admin_only, only: [:create, :update, :destroy]
  before_action :set_paper_trail_whodunnit

  def context
    { current_user: current_user }
  end

  private

  def exclude_customer
    if current_user.customer?
      render status: :forbidden, json: { message: 'Access denied' }
    end
  end

  def admin_only
    unless current_user.admin?
      render status: :forbidden, json: { message: 'Access denied' }
    end
  end
end
