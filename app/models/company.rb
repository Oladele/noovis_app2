class Company < ActiveRecord::Base

	### Validations
  validates :name, presence: true

end
