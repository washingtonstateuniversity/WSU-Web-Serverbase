				<article>
            <h1>WSU Serverbase</h1>
            <h2 class="header">Github : <a name="wsumage-base" href="https://github.com/washingtonstateuniversity/WSU-Web-Serverbase">WSU-Web-Serverbase</a></h2>
            <div class="wrapper markdown-body">
              <section>
                  <h3>Overview</h3>
                  <p>This is a project that is meant to create a server environment in one of two locations.  One is with a Vagrant controlling a headless VirtualBox, and the other is on a Centos 6.5 server.  You can look through the <a href="https://github.com/washingtonstateuniversity/WSU-Web-Serverbase">WSU-Web-Serverbase repo</a> for details but this mirco site is meant to give you a simple overview of how to use and what is done.  This project may be loaded with web apps such as <code>Magento</code>,<code>Elasticsearch</code>,<code>Wordpress</code>, or any other app that has be set up to be provisioned.  To get the LEMP setup running for the first time, there are only a few step needed. </p>
                  
                  
<h3>For Local deveploment</h3>
<h4>Quick install:</h4>
                  <ol>
<li>Install required applications:

	<ol>
		<li>
		Git (<a href="http://windows.github.com/">Windows</a> or <a href="http://mac.github.com/">OSX</a>) More infomation on <a href="http://git-scm.com/">Git</a> and <a href="http://git-scm.com/downloads">other client downloads</a>
		</li>
		<li><a href="http://www.vagrantup.com/">Vagrant</a></li>
		<li><a href="https://www.virtualbox.org/">VirtualBox</a></li>
	</ol>
		<strong>NOTE:</strong> There has been versions of Vagrant and VirtualBox that do play well with each other.  We will try to keep up a list of combinations that had been noted to not work. 
</li>




<li>Clone the WSU Web Serverbase repository to a directory on your local machine.

<pre>
<code>git clone git@github.com:washingtonstateuniversity/WSU-Web-Serverbase.git wsuweb
cd wsuweb</code>
</pre>
</li>
					  
<li><strong>Prep your local machine.</strong>
	<p>In order to gain all the advantages of this you'll need to install a few plugins that will magange you host file and VirtualBox guest additions.</p>
<pre>
<code>vagrant plugin install vagrant-hosts
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-vbguests</code>
</pre>
</li>

<li>
<p>Start the local server:</p>
<pre>
<code>vagrant up</code>
</pre>

<strong>NOTE:</strong> If you would like to do some logging of <code>Vagrant</code> setup, you can use <code> vagrant up | tee log.txt</code> instead.  There will be a log of the whole run located at <code>wsuweb/log.txt</code>.  Also <strong>The default quick run installs Magento as an app of the server.</strong> 

<h3>Windows Users Have one more step before starting</h3>
<p>Since the sytem handles your dns entries for you, so you don't have to edit your host file all the time, the system must be able to have access to that file.  In order to give the system access you follow these steps:</p>

<ul> 
<li>Browse to C:\Windows\System32\Drivers\etc </li>
<li>Right click on the <code>hosts</code> file and select <code>properties</code></li>
<li>click the Security tab</li>
<li>Click the <code>Advanced</code> button</li>
<li>Give the <code>System</code> and <code>Users</code> Full control</li>
</ul>
	
<p>Once this has been done test it by opening the hosts file in an app like notepad.  Add a new line and <code>#</code> (# is a comment) and then save the file.  If the file saves, then you should be ok.</p>
	
	
</li>
</ol>
<h3>Configure Local installs</h3>
<p>There are many options you can set for the whole process.  Since the whole process is comprised of `Vagrant` and `Salt` with a few other, instead of requiring you to edit each in the respective locations, there is one config file to edit.  Read more on how to change settings and add more apps <a href="">here</a></p>
					</section>
				</article>