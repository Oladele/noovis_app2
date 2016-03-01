FactoryGirl.define do
  factory :import_cable_run do
    skip_create
    file { File.open(File.join(Rails.root, 'spec', 'support', 'test.xls')) }
    sheet "Sheet1"
    building_id 1
  end
end
