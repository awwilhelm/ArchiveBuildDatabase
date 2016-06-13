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
		build = Array.new
		buildTarWindows32 = Build.new
		buildTarWindows64 = Build.new
		buildTarMacIntel = Build.new
		buildTarMacIntel64 = Build.new
		buildTarMacUniversal = Build.new


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
		puts "-- Cloning the following Git Repository: #{@github_url} --\n"
		result = %x(git clone #{@github_url} #{@assets_folder})
		puts result

		#Create Build
		puts "-- Creating all of the Unity builds --\n"
		result = %x("#{@unity_path}" -quit -batchmode -executeMethod BuildScript.All -projectPath "#{@project_path}")
		puts result
#
		##Zip Build folder
		result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneWindows32.tar.gz StandaloneWindows32)
		puts result
		result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneWindows64.tar.gz StandaloneWindows64)
		puts result

		#result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXIntel.tar.gz StandaloneOSXIntel)
		#puts result
		#result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXIntel64.tar.gz StandaloneOSXIntel64)
		#puts result
		#result = %x(cd app/assets/build_archive/#{current_build_id_str}/Build && tar -zcvf StandaloneOSXUniversal.tar.gz StandaloneOSXUniversal)
		#puts result

		#Define the different builds into an array of Build Models
		buildTarWindows32.build_id = buildTarWindows64.build_id = buildTarMacIntel.build_id = buildTarMacIntel64.build_id = buildTarMacUniversal.build_id 			= current_build_id_str 

		buildTarWindows32.architecture_type 	= "Windows32"
		buildTarWindows64.architecture_type 	= "Windows64"
		buildTarMacIntel.architecture_type 		= "Mac"
		buildTarMacIntel64.architecture_type 	= "Mac64"
		buildTarMacUniversal.architecture_type 	= "MacUniversal"

		buildTarWindows32.zip_type = buildTarWindows64.zip_type = buildTarMacIntel.zip_type = buildTarMacIntel64.zip_type = buildTarMacUniversal.zip_type			= "tar"

		buildTarWindows32.filepath 				= "#{@project_path}\\Build\\StandaloneWindows32.tar.gz"
		buildTarWindows64.filepath 				= "#{@project_path}\\Build\\StandaloneWindows64.tar.gz"
		buildTarMacIntel.filepath 				= "#{@project_path}\\Build\\StandaloneOSXIntel.tar.gz"
		buildTarMacIntel64.filepath 			= "#{@project_path}\\Build\\StandaloneOSXIntel64.tar.gz"
		buildTarMacUniversal.filepath 			= "#{@project_path}\\Build\\StandaloneOSXUniversal.tar.gz"

		buildTarWindows32.time = buildTarWindows64.time = buildTarMacIntel.time = buildTarMacIntel64.time = buildTarMacUniversal.time 								= Time.now

		build.push(buildTarWindows32)
		build.push(buildTarWindows64)
		#build.push(buildTarMacIntel)
		#build.push(buildTarMacIntel64)
		#build.push(buildTarMacUniversal)

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
