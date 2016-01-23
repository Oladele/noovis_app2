class NetworkSite < ActiveRecord::Base
  belongs_to :company
  has_many :buildings

  validates :name, presence: true
  validates :company_id, presence: true
  validates :name, uniqueness: { scope: [:company_id] }

end
