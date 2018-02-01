require 'rails_helper'

RSpec.describe Image, type: :model do
  describe "Initializing Images" do
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
  describe "Creating and Retreiving Images" do
    let(:invalid_type_image) {mock_file_request('invalid_type.gif', 'image/gif')}
    let(:invalid_png_image_size) {mock_file_request('invalid_image.png', 'image/png')}
    let(:valid_png_image) {mock_file_request('valid_image.png', 'image/png')}
    before(:each) do
      FileUtils.rm_rf(Image::IMAGES_PATH) if Dir.exist?(Image::IMAGES_PATH)
    end

    it "retreiving images should always return successful" do
      img_result = Image.all
      expect(img_result[:success]).to be(true)
    end

    it "retreiving images should create an empty stored images folder if there isn't one" do
      expect(Dir.exist?(Image::IMAGES_PATH)).to be(false)
      img_result = Image.all
      expect(img_result[:success]).to be(true)
      expect(img_result[:message]).to eq("Folder not found! Successfully created new one!")
      expect(Dir.exist?(Image::IMAGES_PATH)).to be(true)
    end

    it "uploading images should return unsucessful if the image is invalid" do
      img_result = Image.upload(invalid_type_image)
      expect(img_result[:success]).to be(false)
      expect(img_result[:message]).to eq("Unsupported file type! must be .png or .jpg")
      img_result_2 = Image.upload(invalid_png_image_size)
      expect(img_result_2[:success]).to be(false)
      expect(img_result_2[:message]).to  include("Invalid image size! Height and width are expected to be between")
    end

    it "uploading invalid images should not create the stored images folder if it doesn't already exists" do
      img_result = Image.upload(invalid_type_image)
      expect(img_result[:success]).to be(false)
      expect(Dir.exist?(Image::IMAGES_PATH)).to be(false)
    end

    it "should upload successfully and retreive the image once created" do
      img_result = Image.upload(valid_png_image)
      expect(img_result[:success]).to be(true)
      expect(Dir.exist?(Image::IMAGES_PATH)).to be(true)
      img_retreive_result = Image.all
      expect(img_retreive_result[:success]).to be(true)
      expect(img_retreive_result[:image_paths]).to be_a(Array)
      expect(img_retreive_result[:image_paths].length).to be(1)
    end
  end
end
