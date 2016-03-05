class NetworkSite < ActiveRecord::Base
  belongs_to :company
  has_many :buildings, dependent: :destroy
  has_many :workbooks, dependent: :destroy

  validates :name, presence: true
  validates :company_id, presence: true
  validates :name, uniqueness: { scope: [:company_id] }

end
