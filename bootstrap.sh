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

  if [ ! -d /srv/salt/base ];
  then
  
    yum install -y unzip
  
    cd / && mkdir -p /srv/salt/base
    cd / && mkdir -p /src/salt
    cd /src/salt && curl -o wsu-web.zip -L https://github.com/washingtonstateuniversity/WSU-Web-Serverbase/archive/master.zip
    cd /src/salt && unzip -po wsu-web.zip
  
    ln -s /src/salt/WSU-Web-Serverbase-master/provision/salt /srv/salt/base

    cp /srv/salt/base/config/yum.conf /etc/yum.conf
    sh /srv/salt/base/boot/bootstrap_salt.sh
    cp /srv/salt/base/salt/minions/wsuwp-vagrant.conf /etc/salt/minion.d/
  fi
  
