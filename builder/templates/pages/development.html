{% markdown %}
# WSU Serverbase development guide

## What is this for?
This project is used in aiding your development and web design tasks. To achieve this result of a simple get up and running environment, we use [Vagrant](http://www.vagrantup.com/) along with a [Salt](http://www.saltstack.com/) provisioner to set up the local server and deploy the web apps.  You have the option to edit the `Vagrantfile`, it is highly suggested to not alter the file in any way.  To set options for  `Vagrant` there are properties located in the `config.json`.  From this `config.json` you may load up any of the pre-configured apps, adjust the way vagrant is run, and which environments are loaded with `Salt`. 
		

### Vagrant options
At the top of the `config.json`, which is a json file, you have some options that you may use to change your environment that you are loading.
```json
{
    "webserver": {                            //Name of the server being set up
        "ip":"10.255.255.2",                  //ip of the VirturalBox
        "branch":"master",                    //the git branch to use (optional)
        "owner":"washingtonstateuniversity",  //the git owner to use (optional)
        "open_ports":"",                      //ports to open up for multi server setups
        "hostname":"web_server",              //name of the host
        "memory":"6144",                      //How much memory would you like to share from your host
        "cores":"2",                          //How many processor from the host do you want to share
        "host_64bit":"false",                 //If you are on windows and are sharing more then 2 cores set to true
        "install_type":"testing",             //Type of install
        "minion":"vagrant",                   //Which Salt minion to run
        "verbose_output":"true",              //How much do you want to see in the console
    }
}```



#### `ip`
Set the ip of the virtual server's IP address.  Use a IPv4 (0.0.0.0) that can be navigated to.

#### `branch`
Sets the git branch to use for the server base.

#### `owner`
Sets the git owner to use for the server base.

#### `open_ports`
Setting ports to open up for multi server setups.  If you want to have two server talk to each other then you can set ports to talk through.

#### `hostname`
Set the hostname used

#### `memory`
Set memory used from you host.  It is suggested that you use no more than 50% of you host ram.

#### `cores`
Set CPU cores used from you host.  It is suggested that you use no more than 50% of you host's cores.

#### `host_64bit`
If you are on windows and are sharing more than 2 cores set to true.

#### `install_type`
Type of install

#### `minion`
The minion to use

#### `verbose_output`
Setting the verbose_output option will set the amount of information output to the console


###How to add a web app?
Loading a web app is very straight forward.  You define the app in the config file and the system will do the rest for you.  Look to the smaple for the `Magento` app set up.  The baiscs of the current process is that you define a app blocks you wish to load.  In the next version the app block will be much simplar and allow for more power.  Currently you'll define the app you want to load like this

```json
		"apps": {
			"store.wsu.edu": {
				"repo":"https://github.com/washingtonstateuniversity/WSUMAGE-base.git",
				"repoid":"washingtonstateuniversity/WSUMAGE-base",
				"database_host":"10.255.255.3",
				"hosts":[
					"store.mage.dev",
					"events.store.mage.dev",
					"student.store.mage.dev",
					"general.store.mage.dev",
					"store.admin.mage.dev",
					"tech.store.mage.dev"
				]
			}
		}
```



## Sample working file
This is the file used by the main repo maintainer for general development of the `Magento` app for WSU.
```json
{
	"web_server": {
		"ip":"2",
		"branch":"ssl_updates",
		"owner":"jeremyBass",
		"open_ports":"",
		"hostname":"web_server",
		"memory":"16000",
		"vram":"8",
		"cores":"4",
		"host_64bit":"true",
		"install_type":"testing",
		"minion":"vagrant",
		"verbose_output":"true",
		"remote_env":[
			"serverbase",
			"database",
			"security",
			"web",
			"webcaching"
		],
		"local_env":[
			"serverbase",
			"database",
			"security",
			"web",
			"webcaching"
		],
		"shared_folders":{
			"/var/app":{
				"dest":"/var/app",
				"from":"app",
				"user":"uid=510,gid=510",
				"dmode":"dmode=775",
				"fmode":"fmode=774"
			}
		},
		"apps": {
			"store.wsu.edu": {
				"repo":"-b master https://github.com/jeremyBass/WSUMAGE-base.git",
				"repoid":"jeremyBass/WSUMAGE-base",
				"database_host":"10.255.255.3",
				"hosts":[
					"store.mage.dev",
					"events.store.mage.dev",
					"student.store.mage.dev",
					"general.store.mage.dev",
					"store.admin.mage.dev",
					"tech.store.mage.dev"
				]
			}
		}
	}
}
```


**Note:** More to come. Thank you for reading.
	
{% endmarkdown %}
