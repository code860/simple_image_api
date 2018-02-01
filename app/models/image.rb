class Image
  ###########
  #Constants#
  ###########
  IMAGES_PATH = "#{Rails.root.join('public/stored_images')}".freeze
  VALID_TYPES = ["png", "jpg"].freeze
  MIN_SIZE = 350
  MAX_SIZE = 5000

  #Instance Methods
  attr_reader :width, :height, :original_filename, :file_type, :stored_file_name
  def initialize(image_data)
    validate_and_set(image_data)
  end

  def full_file_path
    "#{IMAGES_PATH}/#{@stored_file_name}"
  end

  #Class Methods
  def self.upload(image_data)
    success = true
    msg = "Successfully uploaded file"
    new_img_path = ""
    begin
      img = self.new(image_data)
      Dir.mkdir(IMAGES_PATH) unless Dir.exist?(IMAGES_PATH)
      File.open(img.full_file_path, "wb") { |f| f.write(image_data.read)}
      new_img_path = img.stored_file_name
    rescue Exception => e
      success = false
      msg = e.to_s
    end
    return {success: success, message: msg, img_path: new_img_path }
  end


  def self.all
    success = true
    msg = "Successfully retrieved images"
    image_paths = []
    begin
      if Dir.exist?(IMAGES_PATH)
        Dir.chdir(IMAGES_PATH)
        image_paths = Dir.glob(['*.png', '*.jpg' ])
      else
        Dir.mkdir(IMAGES_PATH)
        msg = "Folder not found! Successfully created new one!"
      end
    rescue Exception => e
      success = false
      msg = e.to_s
    end
    return {success: success, message: msg, image_paths: image_paths}
  end

  private

  def validate_and_set(image_data)
    raise "Image data is blank!" if image_data.blank?
    raise "Image data is not a file" unless image_data.is_a?(ActionDispatch::Http::UploadedFile)
    @original_filename = image_data.original_filename
    @file_type = @original_filename.split('.').last
    validate_type
    validate_size(image_data)
    @stored_file_name = "#{SecureRandom.urlsafe_base64}.#{file_type}"
    image_data.rewind
  end


  def validate_type
    raise "Unsupported file type! must be .png or .jpg" unless VALID_TYPES.include?(@file_type)
  end

  def validate_size(image_data)
    get_dimensions(image_data)
    raise "Invalid image size! Height and width are expected to be between #{MIN_SIZE}
      ,#{MAX_SIZE}.  Current Image dimensions are W: #{@width} H: #{@height}." unless valid_width? && valid_height?
  end

  def valid_height?
    @height.blank? ? false : (@height >= MIN_SIZE && @height <= MAX_SIZE)
  end

  def valid_width?
    @width.blank? ? false : (@width >= MIN_SIZE && @width <= MAX_SIZE)
  end

  #Get the dimensions using the Image Size Gem
  def get_dimensions(image_data)
    image_data.rewind #Just in case
    img = ImageSize.new(image_data.read)
    @width = img.width
    @height = img.height
  end
end
