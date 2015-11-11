{% markdown %}
# Trouble Shooting

### The box will not come up
If you are on windows, it seems that there can be issues of stability when the VirtualBox guest version is different than the box version.  There are other things that seem to get in the way so here is how we can root out the cause.

* first thing is to see what the box is doing.  In order to do this we need to have the gui open up.  You can do this by setting the option in the config file for Vagrant.  Currently you'll need to go in to the `Vagrantfile` and alter `v.gui = false` to true.  Once this is done you'll be able to watch the box come up.  

* We use a box that currently has a guest version of 4.3.6.  Check the version of VituralBox you have install, it'll most likely be a version newer then 4.3.6.  The best thing to do is uninstall VituralBox and install the older version from the [Old Builds list](https://www.virtualbox.org/wiki/Download_Old_Builds_4_3)

### Things are super slow
If you are on windows the file system takes a little longer.  There are ways to help with this, consider one or all of these steps to increase the responsiveness.

* Add an Solid State Drive (SSD) to your system.  Once you have this then you'll want to set things up so that your repo is run from the SSD.
* Add as much RAM as you can to your system.  You get to set the amount of RAM in the config, so it'd be best to ask for more RAM for your system.  RAM is super cheap these days so getting up to 16 or 32 GB of ram is not that much.  It can improve your workflow greatly and speed your local server up which speeds your development up.
* Allocate as many cpu cores as you can to the local server.  Now a day's many systems have dual/quad core systems, so add as many as you can.  Do this with the [core option](http://washingtonstateuniversity.github.io/WSU-Web-Serverbase/site/development.html#-cores-)

### I made a change to my php code, but nothing changed
By default opcache is loaded in the base install and turned on.  When you are doing your work you can just add `opcache_reset();` at the very first thing that runs your app.  In most cases it'll be an index.php file so you'd put it right after the first '<?php' like so

```php
<?php
    opcache_reset();
```

Also you can use the `opcache` command to flush all of the cache

```bash
touch /var/ngx_pagespeed_cache/cache.flush
```


As we encounter issues, we'll update this list to help ensure you get the most out of the system.
{% endmarkdown %}