class DemoController < ApplicationController

before_action :check_configuration

  def check_configuration
    render 'configuration_missing' if Cloudinary.config.api_key.blank?
  end

	def index
		res = Cloudinary::Api.resources(resource: 'image', format: 'pdf', max_results: 500)
		@resources = res['resources']
		render 'demo/resources'
  end
	
	def new 
		render 'demo/new'
	end
	
	def new_upload
		file = params["file"]
		Cloudinary::Uploader.upload(file, :resource_type => :image,
    :public_id => "asdf2",
    :chunk_size => 6_000_000
		)
		render 'demo/index'
	end
  
	def pdfs
		res = Cloudinary::Api.resources(resource: 'image', format: 'pdf', max_results: 500)
		@pdfs = res['resources'].select{|r|r["format"]== 'pdf'}
		render 'demo/pdfs'
	end

  private

  def local_image_path(name)
    Rails.root.join('uploads', name).to_s
  end

end
