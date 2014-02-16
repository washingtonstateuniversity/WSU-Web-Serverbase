if !@destroying
    
    tempfilename = "#{@vagrant_dir}/provision/salt/minions/_template.conf"
    filename = "#{@vagrant_dir}/provision/salt/minions/#{@server_obj[:minion]}_#{@server_obj[:hostname]}.conf"
    text = File.read(tempfilename)
    
    $PILLARFILE=   "#PILLAR_ROOT-\n"
    $PILLARFILE << "pillar_roots:\n"
    $PILLARFILE << "  base:\n"
    $PILLARFILE << "    - /srv/salt/base/pillar\n"
    
    $ROOTFILE=   "#FILE_ROOT-\n"
    $ROOTFILE << "file_roots:\n"
    $ROOTFILE << "  base:\n"
    $ROOTFILE << "    - /srv/salt/base\n"
    
    $SALT_ENV=   "#ENV_START-\n"
    $SALT_ENV << "  env:\n"
    $SALT_ENV << "    - base\n"
    $SALT_ENV << "    - vagrant\n"

    
    if @server_obj[:local_env]
        @server_obj[:local_env].each do |env|
            envname=env.to_s
            $SALT_ENV << "    - #{envname}\n"
        end
    end

    if @apps
        @apps.each_pair do |name, obj|
            appname=name.to_s
            $SALT_ENV << "    - #{appname}\n"
        
            $PILLARFILE << "  #{appname}:\n"
            $PILLARFILE << "    - /srv/salt/#{appname}/pillar\n"
            
            $ROOTFILE << "  #{appname}:\n"
            $ROOTFILE << "    - /srv/salt/#{appname}\n"
        end
    end

    $SALT_ENV << "#ENV_END-"
    $PILLARFILE << "#END_OF_PILLAR_ROOT-"
    $ROOTFILE << "#END_OF_FILE_ROOT-"
    
    edited = text.gsub(/\#FILE_ROOT-.*\#END_OF_FILE_ROOT-/im, $ROOTFILE)
    edited = edited.gsub(/\#PILLAR_ROOT-.*\#END_OF_PILLAR_ROOT-/im, $PILLARFILE)
    edited = edited.gsub(/\#ENV_START-.*\#ENV_END-/im, $SALT_ENV)
    File.open(filename, "w") { |file| file << edited }

end