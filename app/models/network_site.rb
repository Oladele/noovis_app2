# == Schema Information
#
# Table name: network_sites
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string
#  company_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lat        :decimal(10, 6)
#  lng        :decimal(10, 6)
#

class NetworkSite < ActiveRecord::Base
  belongs_to :company
  has_many :buildings, dependent: :destroy
  has_many :workbooks, dependent: :destroy

  validates :name, presence: true
  validates :company_id, presence: true
  validates :name, uniqueness: { scope: [:company_id] }

end
