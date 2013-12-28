WSU-serverbase-centos
=====================
Stuff to be said later




#Server base
A very reactive base is loaded where you are able to add a project like `Wordpress`, `Magento`, `elasticsearch` and really anything that would run on a typical LEMP set up.  This project lets us use one server base that can be augmented by a project.  All that needs to be done is to define the projects that are loaded from a git repository in the `pillar/projects.sls`.   Nothing else needs to be done.  An example is:

    projects:
      store.wsu.edu:
        name: git://github.com/jeremyBass/WSUMAGE-base.git
        rev: master
        target: store.wsu.edu
        
This `projects.sls` says that we should be calling for a sub project and putting it in the `/www/store.wsu.edu/` directory.  This base server will look for the `store.wsu.edu` projects provisionor set up and run it after this servers own provisioning.  This lets us keep the server environment clean of the web applications stuff.  


##Install

1. install the base apps
    
    > 1. GITHUB ([win](http://windows.github.com/)|[mac](http://mac.github.com/)) 
    > 1. [Vagrant](http://www.vagrantup.com/) (for [help installing see wiki](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-Vagrant))
    > 1. [VirtualBox](https://www.virtualbox.org/) (for [help installing see wiki](https://github.com/washingtonstateuniversity/WSUMAGE-vagrant/wiki/Installing-Vagrant))
    
1. run in powershell/command line 
        
        $ git clone git://github.com/jeremyBass/WSU-serverbase-centos.git devserver

1. move to the new directory 
        
        $ cd devserver

1. (optional) add a project to be included in the `pillar/projects.sls`

        projects:
          store.wsu.edu:
            name: git://github.com/jeremyBass/WSUMAGE-base.git
            rev: master
            target: store.wsu.edu

1. run in powershell/command line/terminal 
        
        $ vargant up


##File structure
The project it's self will just set up the server base that a recipe is based off(ie:file server/ proxy/ database server).


###Sub projects
An example usage is that we will set up an install of Magento for the WSU Magento setup.  It is a submodule to this project and would be installed as such.  This will let us keep one known server style that can be used for many set ups.  This is the basic folder structure:

    -{clone directory}      - this is the clone folder for this project
     |-/www                 - the www host folder that comes with this project
     | |-/{project name}    - the project is a subtree and is loaded
     |   |--/html           - | the web root for this project
     |   |--/provision      - | the provisioner folder
     |      |--/salt        - | the salt provisioner
     |         |--host      - | the host file listing the domains (\n delimited)
     |         |--/config   - | salt config folder
     |         |--/minions  - | salt minions folder
     |         |--/pillar   - | salt pillar folder
     |         |--top.sls   - | salt top file that sets things in line
     |   |--/stage          - | staging folder

An Example implementation:

    -wsumage
     |-/www
     | |-/store.wsu.edu
     |   |--/html
     |   |--/provision
     |      |--/salt
     |         |--host
     |         |--/config
     |         |--/minions
     |         |--/pillar
     |         |--top.sls
     |   |--/stage
     |      |--installer.php
     | |-/cbn.wsu.edu
     |   |--/html
     |   |--/provision
     |      |--/salt
     |         |--host
     |         |--/config
     |         |--/minions
     |         |--/pillar
     |         |--top.sls
     |   |--/stage
     |      |--installer.php
     
to make it clear the sub project is set up 

     |-/{project name}    - this is loaded from the base as it has no webserver of its own
     | |--/html           - when we map the host file it'll be to this folder
     | |--/provision      - we make the project stateful through the provision
     |    |--/salt        - the salt provisioner of choice
     |       |--host      - the host file listing the domains (\n delimited)
     |       |--/config   - salt config folder
     |       |--/minions  - salt minions folder
     |       |--/pillar   - salt pillar folder
     |       |--top.sls   - salt top file that sets things in line
     | |--/stage          - load install scripts here.