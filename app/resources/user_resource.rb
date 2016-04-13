class UserResource < JSONAPI::Resource
  attributes :email, :password, :password_confirmation
  has_one :company
  
  filter :company
end
