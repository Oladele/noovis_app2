class NetworkGraph < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :network_template
end
