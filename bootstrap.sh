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
set -o nounset                              # Treat unset variables as an error
__ScriptVersion="0.1.0"
__ScriptName="bootstrap.sh"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
SCRIPT=${0##*/}
IFS=$''
usage() {
    cat << END
    
  Usage :  ${__ScriptName} [options]

  Command Examples:
    $ ${__ScriptName} $(tput bold)-m <minion>$(tput sgr0)
                => Install a module by cloning specified git repository


  Options:
  -v   Show gitploy version
  
  -h   Show this help
  
  -m   (Minion) Use a minion of choice.  Defaults to first one found
  
  -o   (Owner) The owner of the repo to draw from    
  
  -b   (Branch) The branch to use for the server repo
  
  -t   (Tag) The tag to use for the server repo
  
  **COMING
  -d   (Dry run) Dry run mode (show what would be done)

END
}
# ----------  end of usage  ----------

_MINION="vagrant"
_OWNER="washingtonstateuniversity"
_BRANCH=""
_TAG=""

#===  FUNCTION  ================================================================
#          NAME:  echoerr
#   DESCRIPTION:  Echo errors to stderr.
#===============================================================================
echoerror() {
    printf "ERROR: $@\n" 1>&2;
}



#===  FUNCTION  ================================================================
#          NAME:  init_boot
#   DESCRIPTION:  starts the booting of the provisioning.
#===============================================================================
init_boot() {
    #this is very lazy but it's just for now
    rm -fr /src/salt

    #install git
    yum install -y git
}

#===  FUNCTION  ================================================================
#          NAME:  init_provision
#   DESCRIPTION:  starts the booting of the provisioning.
#===============================================================================
init_provision(){
    which git ls 2>&1 | grep -qi "/usr/bin/which: no git " && init_boot
    #ensure the src bed
    [ -d /src/salt ] || mkdir -p /src/salt
    [ -d /srv/salt/base ] || mkdir -p /srv/salt/base
    
    #start cloning it the provisioner
    [[ -z "${_BRANCH}" ]] || _BRANCH=' -b '$_BRANCH
    [[ -z "${_TAG}" ]] || _TAG=' -t '$_TAG
    
    git_cmd="git clone --depth 1 ${_BRANCH} ${_TAG} https://github.com/${_OWNER}/WSU-Web-Serverbase.git"
    
    cd /src/salt && eval $git_cmd 
    [ -d /src/salt/WSU-Web-Serverbase/provision  ] && mv -fu /src/salt/WSU-Web-Serverbase/provision/salt/* /srv/salt/base/
    
    #make app folder
    [ -d /var/app ] || mkdir -p /var/app
    
    #start provisioning
    rm -fr /etc/yum.conf
    cp -fu --remove-destination /srv/salt/base/config/yum.conf /etc/yum.conf
    sh /srv/salt/base/boot/bootstrap-salt.sh
    cp -fu /srv/salt/base/minions/${_MINION}.conf /etc/salt/minion.d/${_MINION}.conf
}

provision_env(){
    #start the provisioning
    salt-call --local --log-level=info --config-dir=/etc/salt state.highstate env=base
}

#for check salt insalled /etc/salt/pki


# Handle options
while getopts ":vhd:m:o:b:t:i:" opt
do
  case "${opt}" in
  
    v )  echo "$0 -- Version $__ScriptVersion"; exit 0  ;;
    h )  usage; exit 0                                  ;;
    
    m ) _MINION=$OPTARG                                 ;;
    o ) _OWNER=$OPTARG                                  ;;
    b ) _BRANCH=$OPTARG                                 ;;
    t ) _TAG=$OPTARG                                    ;;

    e ) _ENV=$OPTARG                                    ;;

    i ) init_provision                                  ;;
    p ) provision_env                                   ;;

    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument" >&2
      exit 1
      ;;
  esac
done