class UserResource < JSONAPI::Resource
  attributes :email, :password, :password_confirmation, :role
  has_one :company
  
  filter :company

  def fetchable_fields
    super - [:password, :password_confirmation]
  end
end
