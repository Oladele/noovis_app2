class Company < ActiveRecord::Base
	has_many :network_sites, dependent: :destroy

	### Validations
  validates :name, uniqueness: true, presence: true

end
