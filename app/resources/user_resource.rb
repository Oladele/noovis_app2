class UserResource < JSONAPI::Resource
  attributes :email, :password
  has_one :company
  
  filter :company

end
