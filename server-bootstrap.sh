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
cd /
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

# Some truth values
SB_TRUE=1
SB_FALSE=0
SB_QUIET=$SB_FALSE
SB_DEBUG=$SB_FALSE

declare -A _RANENV=()

_REPOURL="https://github.com"
_RAWURL="https://raw.githubusercontent.com"

provisionpath=/srv/salt/base/
_CONFDATA=""

#===  FUNCTION  ================================================================
#          NAME:  is_localhost
#   DESCRIPTION:  Will check if this is a local devlopment by checking if we 
#                 have flaged it local.  By defualt we are on "production"
#===============================================================================
is_localhost() {
  return ip addr show dev eth0 2>&1 | grep "inet " 2>&1 | awk '{ print $2 }' 2>&1 | grep -qi "10.255.255" && true || false
}

#===  FUNCTION  ================================================================
#          NAME:  echoerr
#   DESCRIPTION:  Echo errors to stderr.
#===============================================================================
load_env() {
  if [ -z "$_ENV" ]; then
	_ENV="$1"
  else
	_ENV="$_ENV,$1"
  fi
}


#===  FUNCTION  ================================================================
#          NAME:  echostd
#   DESCRIPTION:  Echo stdout.  Basicly a proxy is what is done
#===============================================================================
echostd() {
	[ $SB_QUIET -eq $SB_FALSE ] && printf "%s\n" "$@";
}

#===  FUNCTION  ================================================================
#          NAME:  echoerr
#   DESCRIPTION:  Echo errors to stderr.
#===============================================================================
echoerr() {
	printf "ERROR: $@\n" 1>&2;
	exit 1
}


#===  FUNCTION  ================================================================
#          NAME:  echoinfo
#   DESCRIPTION:  Echo information to stdout.
#===============================================================================
echoinfo() {
	[ $SB_QUIET -eq $SB_FALSE ] && printf "INFO: %s\n" "$@";
}

#===  FUNCTION  ================================================================
#          NAME:  echowarn
#   DESCRIPTION:  Echo warning informations to stdout.
#===============================================================================
echowarn() {
	[ $SB_QUIET -eq $SB_FALSE ] && printf "WARN$: %s\n" "$@";
}

#===  FUNCTION  ================================================================
#          NAME:  echodebug
#   DESCRIPTION:  Echo debug information to stdout.
#===============================================================================
echodebug() {
	if [ $SB_DEBUG -eq $SB_TRUE ]; then
		printf "DEBUG: %s\n" "$@";
	fi
}

#===  FUNCTION  ================================================================
#          NAME:  prepare_env
#   DESCRIPTION:  set up an environment.
#===============================================================================
prepare_env(){
	return 0
}

#===  FUNCTION  ================================================================
#          NAME:  prepare_minion
#   DESCRIPTION:  set up a minion if it doesn't exist.
#===============================================================================
prepare_minion(){
	return 0
}

#===  FUNCTION  ================================================================
#          NAME:  provision_env
#   DESCRIPTION:  provision an environment.
#===============================================================================
provision_env(){
	salt-call --log-level=info state.highstate env=base
	_RANENV["base"]=1
	
	envs_str=$1
	echo "starting environment run with ${envs_str}"
	IFS=',' read -a envs <<< "${envs_str}"
	for env in ${envs[@]} #loop with key as the var
	do
		echo "looking for ${env}"
		if [ ! -z ${_RANENV["$env"]:-} ]; then
			echo "skipping ${env}"
		else
			echo "running environment ${env}"
			[ -h "/srv/salt/${env}" ] || ln -s /var/app/${env}/provision/salt /srv/salt/${env}
			salt-call state.clear_cache
			salt-call --log-level=info state.highstate env=${env}
			_RANENV["${env}"]=1
		fi
	done
	return 0
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
	
	[ -d /var/app ] || mkdir -p /var/app
	cd /var/app

	if [[ -L "$sympath" && -d "$sympath" ]]; then
		echo "app already linked and init -- ${appname}"
	else
		[ -d "/var/app/${appname}" ] || mkdir -p "/var/app/${appname}"
		cd "/var/app/${appname}"
		
		if [ $(gitploy ls 2>&1 | grep -qi "${modname}") ]; then
			echo "app already linked-- ${modname}"
		else
			gitploy init
			#bring it in with modgit
			gitploy ${modname} "https://github.com/${repopath}.git"
		fi
		ln -s /var/app/${appname}/provision/salt/ ${sympath} && echostd "linked /var/app/${appname}/provision/salt/ ${sympath}"
	fi
	#add the app to the queue of provisioning to do
	load_env ${appname}
	return 0
}



#===  FUNCTION  ================================================================
#          NAME:  load_config_data
#   DESCRIPTION:  loads the settings to global data value.
#===============================================================================
load_config_data(){
	_CONFDATA=$(cat "${provisionpath}config.json")
	$_CONFDATA | jq '.'
}

#===  FUNCTION  ================================================================
#          NAME:  get_config_data
#   DESCRIPTION:  gets the global data value.
#===============================================================================
get_config_data(){
	setting="$1"
	$_CONFDATA | jq ".${setting}"
}

#===  FUNCTION  ================================================================
#          NAME:  init_provision_settings
#   DESCRIPTION:  sets all the setting needed for provisioning.
#===============================================================================
init_provision_settings(){
    confg_file="${provisionpath}config.json"
	if [ -f "$confg_file" ]
	then
		echo "The file $confg_file was found, we will begin"
	else
		done=0
		while [ "x${done}" = x0 ]; do
			echo "Looking for a file at ${provisionpath}"
			echo -n "Please enter the path to the config file: "
				read -p ">>" answer </dev/tty
			if [ -f "${provisionpath}${answer}" ]; then
				echo "The file ${answer} was found, we will begin"
				done=1
				load_config_data
			fi
		done
	fi
	return 0
}

#===  FUNCTION  ================================================================
#          NAME:  init_provision
#   DESCRIPTION:  starts the booting of the provisioning.
#===============================================================================
init_provision(){
	is_localhost && echo "working off a local development platform" || echo "working off a remote server"
	
	#ensure the src bed
	[ -d /src/salt/serverbase ] || mkdir -p /src/salt/serverbase
	[ -d /srv/salt/base ] || mkdir -p /srv/salt/base
	
	#start cloning it the provisioner
	[[ -z "${_BRANCH}" ]] || _BRANCH=' -b '$_BRANCH
	[[ -z "${_TAG}" ]] || _TAG=' -t '$_TAG
	
	#build git command
	#git_cmd="git clone --depth 1 ${_BRANCH} ${_TAG} https://github.com/${_OWNER}/WSU-Web-Serverbase.git"
	git_cmd="gitploy ${_BRANCH} ${_TAG} serverbase https://github.com/${_OWNER}/WSU-Web-Serverbase.git"
	cd /src/salt/serverbase
	[ $(gitploy init 2>&1 | grep -qi "already initialized") ] || gitploy init
	[ $(gitploy ls 2>&1 | grep -qi "serverbase") ] || eval $git_cmd
	[ -h /srv/salt/base/ ] || ln -s /src/salt/serverbase/provision/salt/* /srv/salt/base/

	#start provisioning
	if [ -f /srv/salt/base/config/yum.conf ]; then
		rm -fr /etc/yum.conf 
		cp -fu --remove-destination /srv/salt/base/config/yum.conf /etc/yum.conf
	fi
	
	[ -d /etc/salt/minion.d ] || mkdir -p /etc/salt/minion.d
	sh /srv/salt/base/boot/bootstrap-salt.sh
	

	if[ is_localhost ]
	then
		cp -fu /srv/salt/base/minions/${_MINION}.conf /etc/salt/minion.d/${_MINION}.conf
		echo "vagrant settings"
	else
		init_provision_settings
		echo $(hostname --long) 
		get_config_data "local_env"
	fi

	exit 0

	
	provision_env $_ENV
	return 0
}

#===  FUNCTION  ================================================================
#          NAME:  init_json
#   DESCRIPTION:  adds needed json support to the system.
#===============================================================================
init_json(){
	cd /
	[ -f "jq" ] || wget http://stedolan.github.io/jq/download/linux64/jq
	chmod +x ./jq
	cp jq /usr/bin
}
[ $(which jq 2>&1 | grep -qi "/usr/bin/jq") ] || init_json


#this is very lazy but it's just for now
rm -fr /src/salt
	
#ensure deployment is available
[ $(gitploy -v 2>&1 | grep -qi "Version") ] || curl  https://raw.githubusercontent.com/jeremyBass/gitploy/master/gitploy | sudo sh -s -- install
[ -h /usr/sbin/gitploy ] || echoerr "gitploy failed install"

# Handle options
while getopts ":vhd:m:o:b:t:e:p:a:" opt
do
  case "${opt}" in
  
	v )  echo "$0 -- Version $__ScriptVersion"; exit 0  ;;
	h )  usage; exit 0                                  ;;
	
	m ) _MINION=$OPTARG
	  shift $((OPTIND-1)); OPTIND=1
	  ;;
	  
	#git options---------------
	o ) _OWNER=$OPTARG
	  shift $((OPTIND-1)); OPTIND=1
	  ;;
	b ) _BRANCH=$OPTARG
	  shift $((OPTIND-1)); OPTIND=1
	  ;;
	t ) _TAG=$OPTARG
	  shift $((OPTIND-1)); OPTIND=1
	  ;;

	e ) load_envs $OPTARG                               ;;
	a ) load_app  $OPTARG                               ;;
	p ) provision_env $OPTARG                           ;;

	\?)  echo
		 echoerr "Option does not exist : $OPTARG"
		 usage
		 exit 1
		 ;;

  esac
done

init_provision

