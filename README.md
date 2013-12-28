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

##File structure
The project it's self will just set up the server base that a recipe is based off(ie:file server/ proxy/ database server)


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