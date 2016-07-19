class UsersController < ApiController
  before_action :admin_only, only: [:create, :destroy]
  before_action :validate_user_update, only: [:update]

  private
  
  def validate_user_update
    unless current_user.admin? || current_user.id == params[:id].to_i
      render status: :forbidden, json: { message: 'Access denied' }
    end
  end
end
