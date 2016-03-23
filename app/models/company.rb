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
	has_many :network_sites, dependent: :destroy
	has_many :buildings, through: :network_sites

	### Validations
  validates :name, uniqueness: true, presence: true

end
