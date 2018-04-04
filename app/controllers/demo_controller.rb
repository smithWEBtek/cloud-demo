class DemoController < ApplicationController

before_action :check_configuration

  def check_configuration
    render 'configuration_missing' if Cloudinary.config.api_key.blank?
  end

  def index
    # First, upload local or remote images to Cloudinary.
    # For the purposes of the demo, we do it on each request
    # to keep things simple.
    upload_images
    
    # We can now display the uploaded images and apply transformations on them.
    render
  end

	def new 
		render 'demo/new'
	end

	def new_upload
		binding.pry
		Cloudinary::Uploader.upload('my_image.jpg')
	end

	# def upload
	# 	file = params[:upload]

	# 	Cloudinary::Uploader.upload(
	# 		file, 
	# 		folder: "asdf",
	# 		public_id: "my_file1",
	# 		overwrite: true, 
	# 		notification_url: "mailto:brad@smithwebtek.com",
	# 		resource_type: "pdf"
	# 	)
	# end


	# Assuming that you have a valid set of Cloudinary credentials
	# Assuming that you have downloaded your 'cloudinary.yml' file and put in 'app/config' folder of this app
	# Assuming you have installed the Cloudinary gem (  gem 'cloudinary' ) in Gemfile
	# Assuming you have some uploaded images in your Cloudinary account
	# Assuming you get results back at the cmd line using curl: 
	# $ curl 

	def get_resources
		res = Cloudinary::Api.resources(resource: 'image', format: 'pdf', max_results: 500)
		@resources = res['resources']
		@pdfs = res['resources'].select{|r|r["format"]== 'pdf'}
	end

	def resources_index
		get_resources
		render 'demo/resources'
	end
	
	def pdfs_index
		get_resources
		render 'demo/pdfs'
	end

  private

  def local_image_path(name)
    Rails.root.join('uploads', name).to_s
  end

  def upload_images
    @uploads = {}

    # public_id for the uploaded image is generated by Cloudinary's service.
    @uploads[:pizza] = Cloudinary::Uploader.upload local_image_path("pizza.jpg"),
      :tags => "basic_sample"

    # Same image, uploaded with a custom public_id
    @uploads[:pizza2] = Cloudinary::Uploader.upload local_image_path("pizza.jpg"),
      :tags => "basic_sample", 
      :public_id => "my_favorite_pizza"

    # Eager transformations are applied as soon as the file is uploaded,
    # instead of lazily applying them when accessed by your site's visitors.
    @eager_options = {
      :width => 200, :height => 150, :crop => "scale"
    }
    @uploads[:lake] = Cloudinary::Uploader.upload local_image_path("lake.jpg"),
      :tags => "basic_sample",
      :public_id => "blue_lake",
      # "eager" parameter accepts a list (or just a single item). You can pass
      # names of named transformations or just transformation parameters as we do here.  
      :eager => @eager_options 

    # In the two following examples, the file is fetched from a remote URL and stored in Cloudinary.
    # This allows you to apply transformations and take advantage of Cloudinary's CDN layer.

    @uploads[:couple] = Cloudinary::Uploader.upload "http://res.cloudinary.com/demo/image/upload/couple.jpg",
      :tags => "basic_sample"

    # Here, the transformation is applied to the uploaded image BEFORE storing it on the cloud.
    # The original uploaded image is discarded.
    @uploads[:couple2] = Cloudinary::Uploader.upload "http://res.cloudinary.com/demo/image/upload/couple.jpg",
      :tags => "basic_sample",
      :width => 500,
      :height => 500,
      :crop => "fit",
      :effect => "saturation:-70"
  end

end
