FactoryGirl.define do
  factory :import_job do
    building
    filename "some_filename.csv"
    sheet_name "Sheet 1"
    status "processing"
    created_at 5.minutes.ago

    factory :expired_import_job do
      created_at 1.day.ago
    end
  end
end
