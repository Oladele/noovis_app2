class User < ActiveRecord::Base
  belongs_to :company

  validates :company_id, presence: true
  validates :email, presence: true, uniqueness: true
end
