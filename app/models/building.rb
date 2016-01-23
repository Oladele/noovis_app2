class Building < ActiveRecord::Base
  belongs_to :network_site

  validates :name, presence: true
  validates :network_site_id, presence: true
  validates :name, uniqueness: { scope: [:network_site_id] }
end
