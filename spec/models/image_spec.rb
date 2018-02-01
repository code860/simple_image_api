require 'rails_helper'

RSpec.describe Image, type: :model do
  describe "Creating Images" do
    #STUBS
    let(:invalid_type_image) {mock_file_request('invalid_type.gif', 'image/gif')}
    let(:invalid_png_image_size) {mock_file_request('invalid_image.png', 'image/png')}
    let(:invalid_jpg_image_size) {mock_file_request('invalid_image.jpg', 'image/jpeg')}
    let(:valid_jpg_image) {mock_file_request("valid_image.jpg", 'image/jpeg')}
    #TESTS
    it "should raise error if nil or blank is passed in on new" do
      expect {Image.new(nil)}.to raise_error("Image data is blank!")
      expect {Image.new("")}.to raise_error("Image data is blank!")
    end

    it "should raise error if ActionDispatch::Http::UploadedFile is not passed in" do
      expect {Image.new(SecureRandom.base64)}.to raise_error("Image data is not a file")
      expect {Image.new(Tempfile.new("foobar"))}.to raise_error("Image data is not a file")
    end
    it "should raise error if file type is not a png or jpg" do
      expect {Image.new(invalid_type_image)}.to raise_error("Unsupported file type! must be .png or .jpg")
    end

    it "should raise error if it is an invalid size" do
      expect {Image.new(invalid_png_image_size)}.to raise_error(/Invalid image size! Height and width are expected to be between/)
      expect {Image.new(invalid_jpg_image_size)}.to raise_error(/Invalid image size! Height and width are expected to be between/)
    end

    it "should be a valid instance of Image if the validations pass" do
      expect {Image.new(valid_jpg_image)}.not_to raise_error
    end

    it "should print out the file path of where it is going to be stored" do
      img = Image.new(valid_jpg_image)
      expect(img.original_filename).not_to eq(img.stored_file_name)
      expect(img.full_file_path).to eql("#{Image::IMAGES_PATH}/#{img.stored_file_name}")
    end
  end
end
