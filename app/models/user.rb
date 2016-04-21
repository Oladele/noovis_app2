class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable#, :confirmable, 
  include DeviseTokenAuth::Concerns::User
  belongs_to :company

  validates :company_id, presence: true
  validates :email, presence: true, uniqueness: true
end
