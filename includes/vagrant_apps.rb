

@apps=@server_obj[:apps]
if !@destroying 
	if @apps
		@apps.each_pair do |name, obj|
			appname=name.to_s
			repolocation=obj[:repo].to_s
			if !File.exist?("app/#{appname}")
				puts "cloning repo that was missing"
				puts "git clone #{repolocation} app/#{appname}"
				puts `git clone --depth=1 #{repolocation} app/#{appname}`
			end
		end
	end
end