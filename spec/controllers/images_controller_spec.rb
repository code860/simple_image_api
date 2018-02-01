require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  describe "Retreiving Images" do
    before(:each) do
      FileUtils.rm_rf(Image::IMAGES_PATH) if Dir.exist?(Image::IMAGES_PATH)
    end
    it "should always return as a json hash" do
      get :index
      expect(response).to have_http_status(:ok)
      expect {json_body}.not_to raise_exception
      expect(json_body).to have_key("success")
      expect(json_body).to have_key("message")
      expect(json_body).to have_key("image_paths")
      expect(json_body["image_paths"]).to be_a(Array)
    end
  end
  describe "Uploading images" do
    let(:invalid_type_image) {fixture_file_upload('spec/test_images/invalid_type.gif', 'image/gif')}
    let(:valid_png_image) {fixture_file_upload('spec/test_images/valid_image.png', 'image/png')}
    before(:each) do
      FileUtils.rm_rf(Image::IMAGES_PATH) if Dir.exist?(Image::IMAGES_PATH)
    end
    it "should return a unprocessable_entity status if the image is invalid with a json hash" do
      post :create, params: {:image => invalid_type_image}
      expect(response).to have_http_status(:unprocessable_entity)
      expect {json_body}.not_to raise_exception
      expect(json_body).to have_key("success")
      expect(json_body).to have_key("message")
    end

    it "should return a created status with a json hash" do
      post :create, params: {:image => valid_png_image}
      expect(response).to have_http_status(:created)
      expect {json_body}.not_to raise_exception
      expect(json_body).to have_key("success")
      expect(json_body).to have_key("message")
      expect(json_body).to have_key("img_path")
    end
  end
end
