class BuildsController < ApplicationController
	def index

		#Build.create(build_id: 111, architecture_type: "windows64", zip_type: "tar", filepath: "long", time: Time.now)
#		Build.create(name:"Larry", url: "very long2222")
		@build = Build.new
		@builds = Build.all

		@builds.each do |val|
			puts val.id
		end

#		@build.each do |val|
#			#puts val.destroy
#		end
	end

	def show
		@build = Build.find(params[:id])
	end

	def new
		@build = Build.new
	end

	def create
		#Temp.git_pull
		

		@build = Build.generate_zip("Windows64", "tar")


		Time.zone = "Central Time (US & Canada)"
	 
	  	if @build.save
	  		redirect_to action: :index
	  	else
	  		render 'new'
  		end
	end

	def destroy
	    @build = Build.find(params[:id])
	    @build.destroy
	    redirect_to action: :index
	end

	private
 	    def build_params
 	   		params.require(:build).permit()
 	   		#:build_id, :architecture_type, :zip_type, :filepath, :time
  		end
end
