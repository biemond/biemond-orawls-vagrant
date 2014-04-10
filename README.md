javaexec_log branch
===================

this javaexec_log branch logs all java executions.
see an example log at https://gist.github.com/dportabella/10372181

      $ git clone https://github.com/biemond/biemond-orawls-vagrant
      $ cd biemond-orawls-vagrant
      $ git checkout javaexec_log
      $ mkdir log_puppet_weblogic
      $ chmod a+rwx log_puppet_weblogic
      $ vagrant up admin
      $ cat log_puppet_weblogic/log.txt 


biemond-orawls-vagrant
=======================

The reference implementation of https://github.com/biemond/biemond-orawls  
optimized for linux, Solaris and the use of Hiera

Also support WebLogic resource like 
- wls_machine
- wls_server
- wls_cluster
- wls_safagent
- wls_jmsserver
- wls_file_persistence_store

puppet resource wls_machine --verbose  ( as root or use sudo )

      $domain_address = hiera('domain_adminserver_address')
      $domain_port    = hiera('domain_adminserver_port')

      wls_setting { 'default':
        user               => hiera('wls_os_user'),
        weblogic_home_dir  => hiera('wls_weblogic_home_dir'),
        connect_url        => "t3://${domain_address}:${domain_port}",
        weblogic_user      => hiera('wls_weblogic_user'),
        weblogic_password  => hiera('domain_wls_password'),
      }

      wls_machine { 'test2':
        ensure        => 'present',
        listenaddress => '10.10.10.10',
        listenport    => '5556',
        machinetype   => 'UnixMachine',
        nmtype        => 'SSL',
      }

      wls_server { 'wlsServer3':
        ensure                         => 'present',
        arguments                      => '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out',
        listenaddress                  => '10.10.10.100',
        listenport                     => '8002',
        logfilename                    => '/data/logs/wlsServer3.log',
        machine                        => 'Node1',
        sslenabled                     => '0',
        sslhostnameverificationignored => '1',
        ssllistenport                  => '7002',
      }

      wls_cluster { 'WebCluster':
        ensure         => 'present',
        messagingmode  => 'unicast',
        migrationbasis => 'consensus',
        servers        => 'wlsServer3,wlsServer4',
      }

      wls_safagent { 'jmsSAFAgent1':
        ensure      => 'present',
        servicetype => 'Sending-only',
        target      => 'wlsServer1',
        targettype  => 'Server',
      }

      wls_jmsserver { 'jmsServer1':
        ensure     => 'present',
        target     => 'wlsServer1',
        targettype => 'Server',
      }

      wls_file_persistence_store { 'FileStore':
        ensure     => 'present',
        directory  => '/tmp/aa',
        target     => 'wlsServer1',
        targettype => 'Server',
      }

Details
- CentOS 6.5 vagrant box
- Puppet 3.4.2 with Future Parser
- Vagrant >= 1.41
- Oracle Virtualbox >= 4.3.6 

 Need to set "--parser future" (Puppet >= 3.40) to the puppet configuration, cause it uses lambda expressions for collection of yaml entries from application one and application two. Check the /puppet/apps folder


creates a patched 10.3.6 WebLogic cluster ( admin,node1 , node2 )

site.pp is located here:  
https://github.com/biemond/biemond-orawls-vagrant/blob/master/puppet/manifests/site.pp  

The used hiera files https://github.com/biemond/biemond-orawls-vagrant/tree/master/puppet/hieradata

Add the all the Oracle binaris to /software

edit Vagrantfile and update the software share
- admin.vm.synced_folder "/Users/edwin/software", "/software"
- node1.vm.synced_folder "/Users/edwin/software", "/software"
- node2.vm.synced_folder "/Users/edwin/software", "/software"


used the following software ( located under the software share )
- jdk-7u45-linux-x64.tar.gz

weblogic 10.3.6  ( located under the software share )
- wls1036_generic.jar
- p17071663_1036_Generic.zip ( 10.3.6.06 BSU Patch)


Using the following facts ( VagrantFile )

- environment => "development"
- vm_type     => "vagrant"

When to override the default oracle OS user or don't want to use the user_projects domain folder use the following facts
- override_weblogic_user          => "wls"
- override_weblogic_domain_folder => "/opt/oracle/wlsdomains"


Startup the images

# admin server  
vagrant up admin

# node1  
vagrant up node1

# node2  
vagrant up node2



