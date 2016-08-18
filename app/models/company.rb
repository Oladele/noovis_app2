# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ActiveRecord::Base
  include BustGlobalCache

	has_many :network_sites, dependent: :destroy
	has_many :buildings, through: :network_sites
	has_many :users, dependent: :destroy

	### Validations
  validates :name, uniqueness: true, presence: true

  def network_graphs
    self.buildings.collect { |building| NetworkGraph.latest_for(building) }.compact
  end
end
