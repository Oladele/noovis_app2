# == Schema Information
#
# Table name: network_templates
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  hierarchy   :string           default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class NetworkTemplate < ActiveRecord::Base
  has_many :network_graphs

  validates :name, presence: true
end
