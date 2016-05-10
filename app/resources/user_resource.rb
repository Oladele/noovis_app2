class UserResource < JSONAPI::Resource
  attributes :email, :password, :password_confirmation, :role
  has_one :company
  
  filter :company

  def fetchable_fields
    super - [:password, :password_confirmation]
  end

  def self.records(options = {})
    current_user = options[:context][:current_user]
    if current_user.customer?
      User.includes(:company).where(companies: {id: current_user.company_id}).references(:company)
    else
      super
    end
  end

  def self.updatable_fields(context)
    return super - [:role] unless context[:current_user].admin?
    super
  end
end
