class UsersController < ApiController
  before_action :exclude_customer
end
