# == Schema Information
#
# Table name: buildings
#
#  id              :integer          not null, primary key
#  name            :string
#  lat             :decimal(10, 6)
#  lng             :decimal(10, 6)
#  network_site_id :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Building < ActiveRecord::Base
  belongs_to :network_site
  has_many :sheets, dependent: :destroy

  validates :name, presence: true
  validates :network_site_id, presence: true
  validates :name, uniqueness: { scope: [:network_site_id] }
end
