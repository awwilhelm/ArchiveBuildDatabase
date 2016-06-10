class Temp < ActiveRecord::Base
	def Temp.git_pull
		@github_username = "awwilhelm"
		@github_repository_name = "testClone"

		@unity_path = "C:\\Program Files\\Unity\\Editor\\Unity.exe"
		@mac_unity_path = "/Applications/Unity/Unity.app/Contents/MacOS/Unity"

		@project_path = "C:\\Users\\Alex\\MHSLatestBuild\\app\\assets\\download"

		if File.directory?("app/assets/download")
			result = %x(rm -rf app/assets/download)
			puts result
		end

		#Cloning
		result = %x(git clone https://github.com/#{@github_username}/#{@github_repository_name}.git app/assets/download)
		puts result

		#Create Build
		result = %x("#{@unity_path}" -quit -batchmode -executeMethod BuildScript.MyBuild -projectPath "#{@project_path}")
		puts result

		#Zip Build folder
		#result = %x(cd app/assets/download && tar -jcvf downloadZip.tar.bz2 Build && cd ../../)
		#puts result


		#Compress
		#cd app/assets && tar -jcvf downloadZip.tar.bz2 download && cd ../../

		#Extract
		#tar -jxvf downloadZip.tar.bz2
	end

	def print
		result = "--------------------------------------------------"
		puts result
	end
end
