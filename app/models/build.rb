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
			puts "here is teh following"


			increment_index = current_build_id_split.reverse.each_with_index  do |val, index|
				puts val
				break index if val.to_i < 9
			end


			puts increment_index
			increment_index ||= 0

			increment_index = current_build_id_split.length - 1 - increment_index

			puts "hhh"
			current_build_id_split.each_with_index  do |val, index|
				
				if index>increment_index
					puts val
					puts index
					current_build_id_split[index] = "0"
				end
			end
			puts current_build_id_split
			puts "hhh"

			int = current_build_id_split[increment_index].to_i
			puts "----new #{int}"
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

		puts "_______ version : #{version}"

		return version
	end

	def Build.generate_zip(architecture_type, zip_type)
		build = Build.new

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
		puts "-- Cloning the following Git Repository: #{@github_url} --"
		result = %x(git clone #{@github_url} #{@assets_folder})
		puts result

		#Create Build
		puts "-- Creating all of the Unity builds --"
		#result = %x("#{@unity_path}" -quit -batchmode -executeMethod BuildScript.All -projectPath "#{@project_path}")
		#puts result
		
		puts "After unity build"

		build.build_id = current_build_id_str 
		build.architecture_type = architecture_type
		build.zip_type = zip_type
		build.filepath = @project_path
		build.time = Time.now
		puts "equal"
		return build

		#:build_id, :architecture_type, :zip_type, :filepath, :time
		#Zip Build folder
		#result = %x(cd app/assets/download && tar -jcvf downloadZip.tar.bz2 Build && cd ../../)
		#puts result


		#Compress
		#cd app/assets && tar -jcvf downloadZip.tar.bz2 download && cd ../../

		#Extract
		#tar -jxvf downloadZip.tar.bz2
	end

	
end
