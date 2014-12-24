## biemond-orawls-vagrant

The reference implementation of https://github.com/biemond/biemond-orawls
optimized for linux, Solaris and the use of Hiera

Should work for VMware and Virtualbox

### Details
- CentOS 6.6 Vagrant box
- Puppet 3.7.3
- Vagrant >= 1.6.5
- Oracle Virtualbox >= 4.3.20
- VMware fusion >= 6

creates a patched 10.3.6 WebLogic cluster ( admin,node1 , node2 )

site.pp is located here:
https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp

The used hiera files https://github.com/biemond/biemond-orawls-vagrant/tree/master/puppet/hieradata

Add the all the Oracle binaries to /software

edit Vagrantfile and update the software share
- admin.vm.synced_folder "/Users/edwin/software", "/software"
- node1.vm.synced_folder "/Users/edwin/software", "/software"
- node2.vm.synced_folder "/Users/edwin/software", "/software"

### Software
- jdk-7u55-linux-x64.tar.gz

weblogic 10.3.6
- wls1036_generic.jar
- p17572726_1036_Generic.zip ( 10.3.6.07 BSU Patch)

##Startup the images

###admin server
vagrant up admin

###node1
vagrant up node1

###node2
vagrant up node2
