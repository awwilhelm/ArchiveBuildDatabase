class LatestBuildController < ApplicationController
	def index

#		Build.create(name:"Paul", url: "very long")
#		Build.create(name:"Larry", url: "very long2222")
		@build = Build.new
		@builds = Build.all

		@builds.each do |val|
			puts val.name
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
		@build = Build.new(build_params)
	 
	  	if @build.save
	  		redirect_to @build
	  	else
	  		render 'new'
  		end
	end

	private
 	    def build_params
 	   		params.require(:build).permit(:build_id, :architecture_type, :zip_type, :filepath, :time)
  		end
end
