class NetworkSite < ActiveRecord::Base
  belongs_to :company

  validates :name, presence: true
  validates :company_id, presence: true
  validates :name, uniqueness: { scope: [:company_id] }

end
