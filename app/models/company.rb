class Company < ActiveRecord::Base
	has_many :network_sites

	### Validations
  validates :name, uniqueness: true, presence: true

end
