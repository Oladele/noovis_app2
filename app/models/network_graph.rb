# == Schema Information
#
# Table name: network_graphs
#
#  id                  :integer          not null, primary key
#  sheet_id            :integer
#  network_template_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class NetworkGraph < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :network_template
  has_many :nodes, dependent: :destroy

  validates :sheet_id, presence: true
  validates :network_template_id, presence: true
end
