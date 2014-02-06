#!/bin/bash
#===============================================================================
#          FILE: bootstrap.sh
#
#   DESCRIPTION: Takes a bare systam and starts the creation and state process
#
#          BUGS: https://github.com/washingtonstateuniversity/WSU-Web-Serverbase/issues
#
#     COPYRIGHT: (c) 2014 by the WSU, see AUTHORS.rst for more
#                details.
#
#       LICENSE: Apache 2.0
#  ORGANIZATION: WSU
#       CREATED: 1/1/2014
#===============================================================================


    #install git
    yum install -y git
    
    #ensure the src bed
    [ -d /src/salt ] || mkdir -p /src/salt
    [ -d /srv/salt/base ] || mkdir -p /srv/salt/base

    #start cloning it the provisioner
    cd /src/salt && git clone https://github.com/jeremyBass/WSU-Web-Serverbase.git
    [ -d /src/salt/WSU-Web-Serverbase/provision  ] || mv /src/salt/WSU-Web-Serverbase/provision /srv/salt/base
    
    #make app folder
    [ -d /var/app ] || mkdir -p /var/app

    #start provisioning
    cp /srv/salt/base/config/yum.conf /etc/yum.conf
    sh /srv/salt/base/boot/bootstrap_salt.sh
    cp /srv/salt/base/salt/minions/wsuwp-vagrant.conf /etc/salt/minion.d/
  if [ ! -d /srv/salt/base ];
  then
  
  fi
  
