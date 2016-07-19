class AwsService
  def self.get_file(file_path)
    file = File.open("temp_#{SecureRandom.urlsafe_base64}", 'wb') do |file|
      s3 = Aws::S3::Client.new
      s3.get_object(
        {
          bucket:ENV['S3_BUCKET_NAME'],
          key: file_path
        },
        target: file
      )
    end

    file.body
  end
end
