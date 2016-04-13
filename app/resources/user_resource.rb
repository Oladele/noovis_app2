class UserResource < JSONAPI::Resource
  attributes :email
  has_one :company
  
  filter :company

end
