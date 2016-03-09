FactoryGirl.define do
  factory :node do
    network_graph
    node_type
    node_value "MyString"
    x_pos {9.99}
    y_pos {9.99}
    node_level 1
  end

end
