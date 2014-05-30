#biemond-orawls-vagrant

The reference implementation of https://github.com/biemond/biemond-orawls  
optimized for linux, Solaris and the use of Hiera

##Also support many native puppet WebLogic types like 
- wls_machine
- wls_server
- wls_cluster 
- and many others

##Details
- CentOS 6.5 vagrant box
- Puppet 3.5.0
- Vagrant >= 1.41
- Oracle Virtualbox >= 4.3.6 

creates a patched 10.3.6 WebLogic cluster ( admin,node1 , node2 )

site.pp is located here:  
https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp  

The used hiera files https://github.com/biemond/biemond-orawls-vagrant/tree/master/puppet/hieradata

Add the all the Oracle binaries to /software

edit Vagrantfile and update the software share
- admin.vm.synced_folder "/Users/edwin/software", "/software"
- node1.vm.synced_folder "/Users/edwin/software", "/software"
- node2.vm.synced_folder "/Users/edwin/software", "/software"


##used the following software ( located under the software share )
- jdk-7u51-linux-x64.tar.gz

weblogic 10.3.6  ( located under the software share )
- wls1036_generic.jar
- p17572726_1036_Generic.zip ( 10.3.6.07 BSU Patch)


##Using the following facts ( VagrantFile )

- environment => "development"
- vm_type     => "vagrant"

When to override the default oracle OS user or don't want to use the user_projects domain folder use the following facts
- override_weblogic_user          => "wls"


##Startup the images

###admin server  
vagrant up admin

###node1  
vagrant up node1

###node2  
vagrant up node2


##javaexec_log branch

this javaexec_log branch logs all java executions.
see an example log at https://gist.github.com/dportabella/10372181

      $ git clone https://github.com/biemond/biemond-orawls-vagrant
      $ cd biemond-orawls-vagrant
      $ git checkout javaexec_log
      $ mkdir log_puppet_weblogic
      $ chmod a+rwx log_puppet_weblogic
      $ vagrant up admin
      $ cat log_puppet_weblogic/log.txt 


