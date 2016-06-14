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
		@build = Build.generate_zip()

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

	    #build_id =  Build.find(params[:id]).build_id
	    #@build = Build.all.select do |b|
	    #	b.build_id == build_id
	    #end
	    #@build.each do |b|
	    #	b.destroy
	    #end
	    puts "-- Removing #{build_id} from Build Archive --\n"
	    result = %x(rm -rf app/assets/build_archive/#{build_id})
		puts result

	    redirect_to action: :index
	end
	def download_windows32
		@build = Build.find params[:build_id]

  		send_file "#{@build.filepath}/StandaloneWindows32.tar.gz", disposition: 'attachment'
	end
	def download_windows64
		@build = Build.find params[:build_id]

  		send_file "#{@build.filepath}/StandaloneWindows64.tar.gz", disposition: 'attachment'
	end
	def download_mac
		@build = Build.find params[:build_id]

  		send_file "#{@build.filepath}/StandaloneOSXIntel.tar.gz", disposition: 'attachment'
	end
	def download_mac64
		@build = Build.find params[:build_id]

  		send_file "#{@build.filepath}/StandaloneOSXIntel64.tar.gz", disposition: 'attachment'
	end
	def download_mac_universal
		@build = Build.find params[:build_id]

  		send_file "#{@build.filepath}/StandaloneOSXUniversal.tar.gz", disposition: 'attachment'
	end

	private
 	    def build_params
 	   		params.require(:build).permit()
 	   		#:build_id, :architecture_type, :zip_type, :filepath, :time
  		end
end
