module FileMockHelper
  module MockUpload
    TEST_IMAGES_PATH = "#{Rails.root.join('spec/test_images')}".freeze
    #name = test.png; mime_type = image/png use this link to refer to all mime types https://www.sitepoint.com/mime-types-complete-list/
    def mock_file_request(name, mime_type)
      ActionDispatch::Http::UploadedFile.new({
      :filename => "#{name}",
      :type => "#{mime_type}",
      :tempfile => File.new("#{TEST_IMAGES_PATH}/#{name}")
    })
    end
  end
end
