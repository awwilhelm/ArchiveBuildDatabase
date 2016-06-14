class Build < ActiveRecord::Base
	def Build.increment_build_id
		builds = Build.all
		version = ""
		current_build_id_obj = builds.max do |first,second|
			first.build_id <=> second.build_id
		end
		if current_build_id_obj != nil

			current_build_split = current_build_id_obj.build_id.split("_")
			current_build_id_before = current_build_split[1]
			current_build_id_split = current_build_id_before.split(".")

			increment_index = current_build_id_split.reverse.each_with_index  do |val, index|
				puts val
				break index if val.to_i < 9
			end


			puts increment_index
			increment_index ||= 0

			increment_index = current_build_id_split.length - 1 - increment_index

			current_build_id_split.each_with_index  do |val, index|
				
				if index>increment_index
					puts val
					puts index
					current_build_id_split[index] = "0"
				end
			end
			puts current_build_id_split

			int = current_build_id_split[increment_index].to_i
			next_int = int + 1
			current_build_id_split[increment_index] = "#{next_int}"

			current_build_id_split.each_with_index do |v, index|
				if index < current_build_id_split.length-1
				version += "#{v}."
				else
					version +="#{v}"
				end
			end
		else
			version = "0.0.1"
		end

		return version
	end

	def Build.generate_zip()
		build = Build.new
		@build_windows32 = true
		@build_windows64 = true
		@build_mac = false
		@build_mac64 = false
		@build_mac_universal = false

		current_build_id = Build.increment_build_id

		current_build_id_str = "Build_#{current_build_id}"

		@github_username = "awwilhelm"
		@github_repository_name = "testClone"
		@github_url = "https://github.com/#{@github_username}/#{@github_repository_name}.git"

		@unity_path = "C:\\Program Files\\Unity\\Editor\\Unity.exe"
		@mac_unity_path = "/Applications/Unity/Unity.app/Contents/MacOS/Unity"

		@assets_folder = "app/assets/build_archive/#{current_build_id_str}"
		@project_path = "C:\\Users\\Alex\\MHSLatestBuild\\app\\assets\\build_archive\\#{current_build_id_str}"

		if File.directory?("#{@assets_folder}")
			puts "ERROR: Replaced the folder in the following directory: #{@assets_folder}"
			result = %x(rm -rf #{@assets_folder})
			puts result
		end



		#Cloning
		puts "-- Cloning the following Git Repository: #{@github_url} --\n\n"
		result = %x(git clone #{@github_url} #{@assets_folder})
		puts result

		#Create Build
		puts "-- Creating all of the Unity builds --\n"
		result = %x("#{@unity_path}" -quit -batchmode -executeMethod BuildScript.All -projectPath "#{@project_path}")
		puts result
#
		##Zip Build folder
		puts "-- Compressing Build files --\n"
		if @build_windows32
			result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneWindows32.tar.gz StandaloneWindows32)
			puts result
		end
		if @build_windows64
			result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneWindows64.tar.gz StandaloneWindows64)
			puts result
		end
		if @build_mac
			result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXIntel.tar.gz StandaloneOSXIntel)
			puts result
		end
		if @build_mac64
			result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXIntel64.tar.gz StandaloneOSXIntel64)
			puts result
		end
		if @build_mac_universal
			result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXUniversal.tar.gz StandaloneOSXUniversal)
			puts result
		end

		#result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXIntel.tar.gz StandaloneOSXIntel)
		#puts result
		#result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXIntel64.tar.gz StandaloneOSXIntel64)
		#puts result
		#result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXUniversal.tar.gz StandaloneOSXUniversal)
		#puts result

		#Define the different builds into an array of Build Models
		build.build_id			= current_build_id_str
		build.windows32 		= @build_windows32 
		build.windows64 		= @build_windows64
		build.mac 				= @build_mac
		build.mac64 			= @build_mac64
		build.mac_universal 	= @build_mac_universal
		build.filepath 			= "#{@project_path}\\Build"
		build.time				= Time.now

		return build

		#Zip Build folder
		#result = %x(cd app/assets/download && tar -jcvf downloadZip.tar.bz2 Build && cd ../../)
		#puts result


		#Compress
		#cd app/assets && tar -jcvf downloadZip.tar.bz2 download && cd ../../

		#Extract
		#tar -zxvf fileName.tar.gz
	end

	
end
