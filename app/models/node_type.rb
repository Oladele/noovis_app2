# == Schema Information
#
# Table name: node_types
#
#  id         :integer          not null, primary key
#  name       :string
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class NodeType < ActiveRecord::Base
  has_many :nodes

  validates :name, presence: true
  validates :name, uniqueness: true
end
