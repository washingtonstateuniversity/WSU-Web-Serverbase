config_str_obj=""
configFile="config.json"
if File.exist?("config.json")
	config_str_obj=File.read(configFile).split.join(' ')
else
	config_str_obj = File.read('config.json.sample').split.join(' ')
end
begin
	@vm_pack = JSON.parse(config_str_obj, symbolize_names: true)
	rescue Exception => e
	STDERR.puts "[!] Error when reading the configuration file:",
	e.inspect
end