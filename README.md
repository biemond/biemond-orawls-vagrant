vagrant-wls12c-centos64
=======================

The reference implementation of https://github.com/biemond/biemond-orawls  
optimized for linux and the use of Hiera  

site.pp is located here:  
https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp  
here are the used hiera files https://github.com/biemond/biemond-orawls-vagrant/tree/master/puppet/hieradata

used the following software
- jdk-7u45-linux-x64.tar.gz

weblogic 10.3.6
- wls1036_generic.jar
- p17071663_1036_Generic.zip
- ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip
- ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip
- ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip

weblogic 12.1.2
- wls_121200.jar or fmw_infra_121200.jar
- p16175470_121200_Generic.zip


Detailed vagrant steps (setup) can be found here:

http://vbatik.wordpress.com/2013/10/11/weblogic-12-1-2-00-with-vagrant/

For Mac Users.  The procedure has been and run tested on Mac.


Important: JDK7 Changes of Note as of 10/15/2013

Oracle released a new version of the JDK 1.7u45. This has been reflected and tested in the site.pp file. If you have an older JDK you will need to modify site.pp only. The JDK7 Puppet module does not need to be modified.



