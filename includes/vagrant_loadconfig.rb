config_str_obj=""
configFile="config.json"
if File.exist?("config.json")
    config_str_obj=File.read(configFile).split.join(' ')
else
    config_str_obj = File.read('default_vagrant_config.json').split.join(' ')
end
begin
    @config_obj = JSON.parse(config_str_obj, symbolize_names: true)
    rescue Exception => e
    STDERR.puts "[!] Error when reading the configuration file:",
    e.inspect
end
#######################
# CONFIG Values
#####################
@CONFIG=@config_obj[:vagrant_options]

if !@destroying        
    @config_obj[:apps].each_pair do |name, obj|
        appname=name.to_s
        repolocation=obj[:repo].to_s
        if !File.exist?("app/#{appname}")
            puts "cloning repo that was missing"
            puts "git clone #{repolocation} app/#{appname}"
            puts `git clone --depth=1 #{repolocation} app/#{appname}`
        end
    end
end