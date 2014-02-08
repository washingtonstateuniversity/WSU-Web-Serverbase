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

  $(tput bold)NOTE:$(tput sgr0) github is the only supported repo service at this moment

  Options:
  -a   load a web app
  
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
#start from the root
cd /

_MINION="vagrant"
_OWNER="washingtonstateuniversity"
_BRANCH=""
_TAG=""
_ENV="base"

_RANENV=()





#===  FUNCTION  ================================================================
#          NAME:  echoerr
#   DESCRIPTION:  Echo errors to stderr.
#===============================================================================
load_env() {
    if [[ $_ENV == *$1* ]]; then
      if [ -z "$_ENV" ]; then
        _ENV="$1"
      else
        _ENV="$_ENV,$1"
      fi
    fi
}


#===  FUNCTION  ================================================================
#          NAME:  echoerr
#   DESCRIPTION:  Echo errors to stderr.
#===============================================================================
echoerror() {
    printf "ERROR: $@\n" 1>&2;
}



#===  FUNCTION  ================================================================
#          NAME:  provision_env
#   DESCRIPTION:  provision an environment.
#===============================================================================
provision_env(){
    salt-call --local --log-level=info --config-dir=/etc/salt state.highstate env=base

    envs_str=$1
    IFS=',' read -ra envs <<< "$envs_str"
    for env in "${!envs[@]}" #loop with key as the var
    do
        if [[ ${_RANENV[*]}  =~ ${env} ]]; then
            echo "skipping ${env}"
        else
            salt-call --local --log-level=info --config-dir=/etc/salt state.highstate env=${env}
            _RANENV+=(${env})
        fi
    done
    return 1
}


#===  FUNCTION  ================================================================
#          NAME:  init_modgit
#   DESCRIPTION:  sets up the app deployment pathway.
#===============================================================================
init_modgit(){
    #make app folder
    [ -d /var/app ] || mkdir -p /var/app
    if [ -f /usr/sbin/modgit ]; then
        echo "modgit was already loaded"
    else
        #ensure the deployment bed
        [ -d /src/deployment ] || mkdir -p /src/deployment
        curl https://raw.github.com/jeremyBass/modgit/master/modgit > /src/deployment/modgit
        ln -s /src/deployment/modgit /usr/local/bin/modgit
        ln -s /src/deployment/modgit /usr/sbin/modgit
        ln -s /src/deployment/modgit /etc/init.d/modgit
        
        chmod a=r+w+x /usr/local/bin/modgit
    fi
}

#===  FUNCTION  ================================================================
#          NAME:  load_app
#   DESCRIPTION:  load web app for the server.
#===============================================================================
load_app(){
    echo "loading apps"

    IFS=':' read -ra app <<< "$1"
    
    appname=${app[0]};
    modname=${appname//[-._]/}
    repopath=${app[1]}
    sympath="/srv/salt/${appname}/"
    
    cd /var/app

    if [[ -L "$sympath" && -d "$sympath" ]]; then
        echo "app already linked and init -- ${appname}"
    else
        [ -d "/var/app/${appname}" ] || mkdir -p "/var/app/${appname}"
        cd "/var/app/${appname}"
        modchk= $(modgit ls 2>&1 | grep -qi "${modname}")
        if [ $modchk ]; then
            echo "app already linked-- ${modname}"
        else
            modgit init
            #bring it in with modgit
            modgit add ${modname} "https://github.com/${repopath}.git"
        fi
        ln -s /var/app/${appname}/provision/salt/ ${sympath}
    fi
    #add the app to the queue of provisioning to do
    load_env ${appname}
}


#===  FUNCTION  ================================================================
#          NAME:  init_provision
#   DESCRIPTION:  starts the booting of the provisioning.
#===============================================================================
init_provision(){
    #ensure the src bed
    [ -d /src/salt ] || mkdir -p /src/salt
    [ -d /srv/salt/base ] || mkdir -p /srv/salt/base
    
    #start cloning it the provisioner
    [[ -z "${_BRANCH}" ]] || _BRANCH=' -b '$_BRANCH
    [[ -z "${_TAG}" ]] || _TAG=' -t '$_TAG
    
    git_cmd="git clone --depth 1 ${_BRANCH} ${_TAG} https://github.com/${_OWNER}/WSU-Web-Serverbase.git"
    
    cd /src/salt && eval $git_cmd 
    [ -d /src/salt/WSU-Web-Serverbase/provision  ] && mv -fu /src/salt/WSU-Web-Serverbase/provision/salt/* /srv/salt/base/

    #start provisioning
    [ -f /srv/salt/base/config/yum.conf ] && rm -fr /etc/yum.conf
    [ -f /srv/salt/base/config/yum.conf ] && cp -fu --remove-destination /srv/salt/base/config/yum.conf /etc/yum.conf
    sh /srv/salt/base/boot/bootstrap-salt.sh
    cp -fu /srv/salt/base/minions/${_MINION}.conf /etc/salt/minion.d/${_MINION}.conf
    provision_env $_ENV
}

#this is what everything works around
which git 2>&1 | grep -qi "no git" && yum install -y git

#this is very lazy but it's just for now
rm -fr /src/salt
    
#ensure deployment is available
which modgit || init_modgit

# Handle options
while getopts ":vhd:m:o:b:t:e:i:p:a:" opt
do
  case "${opt}" in
  
    v )  echo "$0 -- Version $__ScriptVersion"; exit 0  ;;
    h )  usage; exit 0                                  ;;
    
    m ) _MINION=$OPTARG                                 ;;
    o ) _OWNER=$OPTARG                                  ;;
    b ) _BRANCH=$OPTARG                                 ;;
    t ) _TAG=$OPTARG                                    ;;

    e ) load_envs $OPTARG                               ;;

    a ) load_app  $OPTARG                               ;;
    i ) init_provision                                  ;;
    p ) provision_env $OPTARG                           ;;

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



