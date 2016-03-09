class Building < ActiveRecord::Base
  belongs_to :network_site
  has_many :sheets, dependent: :destroy

  validates :name, presence: true
  validates :network_site_id, presence: true
  validates :name, uniqueness: { scope: [:network_site_id] }
end
