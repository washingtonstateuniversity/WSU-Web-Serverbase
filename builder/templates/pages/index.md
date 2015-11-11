{% markdown %}
# WSU Serverbase
## Github : [WSU-Web-Serverbase](https://github.com/washingtonstateuniversity/WSU-Web-Serverbase)

### Overview
This is a project that is meant to create a server environment in one of two locations.  One is with a Vagrant controlling a headless VirtualBox, and the other is on a Centos 6.5 server.  You can look through the [WSU-Web-Serverbase repo](https://github.com/washingtonstateuniversity/WSU-Web-Serverbase) for details but this mirco site is meant to give you a simple overview of how to use and what is done.  This project may be loaded with web apps such as `Magento`,`Elasticsearch`,`Wordpress`, or any other app that has be set up to be provisioned.  To get the LEMP setup running for the first time, there are only a few step needed. 
                  
                  
### For Local deveploment
#### Quick install:
1. Install required applications:
	- Git ([Windows](http://windows.github.com/) or [OSX](http://mac.github.com/)) More infomation on [Git](http://git-scm.com) and [other client downloads](http://git-scm.com/downloads)
	- [Vagrant](http://www.vagrantup.com)
	- [VirtualBox](https://www.virtualbox.org/)
	
	**NOTE:** There has been versions of Vagrant and VirtualBox that do play well with each other.  We will try to keep up a list of combinations that had been noted to not work. 

1. Clone the WSU Web Serverbase repository to a directory on your local machine.
	```bash
	git clone git@github.com:washingtonstateuniversity/WSU-Web-Serverbase.git wsuweb
	cd wsuweb
	```

1. **Prepping your local machine.** In order to gain all the advantages of this you'll need to install a few plugins that will magange you host file and VirtualBox guest additions.
	```bash
	vagrant plugin install vagrant-hosts
	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-vbguests
	```
1.  Start the local server: 
	```bash
	vagrant up
	```

**NOTE:** If you would like to do some logging of `Vagrant` setup, you can use `vagrant up | tee log.txt` instead.  There will be a log of the whole run located at `wsuweb/log.txt`.  Also **the default quick run installs Magento as an app of the server.**

### Windows Users Have one more step before starting
Since the sytem handles your dns entries for you, so you don't have to edit your host file all the time, the system must be able to have access to that file.  In order to give the system access you follow these steps:

1. Browse to `C:\Windows\System32\Drivers\etc`
1. Right click on the `hosts` file and select `properties`
1. click the Security tab
1. Click the `Advanced` button
1. Give the `System` and `Users` Full control

Once this has been done test it by opening the hosts file in an app like notepad.  Add a new line and `#` (# is a comment) and then save the file.  If the file saves, then you should be ok.

### Configure Local installs</h3>
There are many options you can set for the whole process.  Since the whole process is comprised of `Vagrant` and `Salt` with a few other, instead of requiring you to edit each in the respective locations, there is one config file to edit.  Read more on how to change settings and add more apps [here](#)

{% endmarkdown %}