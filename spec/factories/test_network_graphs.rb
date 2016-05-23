FactoryGirl.define do
  factory :test_network_graph do
    building
    graph { { hi: 'hey' } }
  end

end
