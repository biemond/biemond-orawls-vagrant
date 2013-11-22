biemond-orawls-vagrant
=======================

The reference implementation of https://github.com/biemond/biemond-orawls  
optimized for linux and the use of Hiera  


creates a patched 10.3.6 WebLogic cluster ( admin,node1 , node2 )


site.pp is located here:  
https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp  

The used hiera files https://github.com/biemond/biemond-orawls-vagrant/tree/master/puppet/hieradata

used the following software
- jdk-7u45-linux-x64.tar.gz

weblogic 10.3.6
- wls1036_generic.jar
- p17071663_1036_Generic.zip

- ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip
- ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip
- ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip

Using the following facts

- environment => "development"
- vm_type     => "vagrant"
- env_app1    => "application_One"
- env_app2    => "application_Two"

also need to set "--parser future" to the puppet configuration, cause it uses lambda expressions for collection of yaml entries from application_One and application_Two


Should also work for WebLogic 12.1.2

weblogic 12.1.2
- wls_121200.jar or fmw_infra_121200.jar
- p16175470_121200_Generic.zip


# admin server  
vagrant up admin

# node1  
vagrant up node1

# node2  
vagrant up node2


Detailed vagrant steps (setup) can be found here:

http://vbatik.wordpress.com/2013/10/11/weblogic-12-1-2-00-with-vagrant/

For Mac Users.  The procedure has been and run tested on Mac.
