# test
#
# one machine setup with weblogic 12.1.2
# creates an WLS Domain with JAX-WS (advanced, soap over jms)
# needs jdk7, orawls, orautils, fiddyspence-sysctl, erwbgy-limits puppet modules
#

node 'vagrantcentos64' {
  
  notify { 'test': 
    message => hiera('messageEnv'), 
  } 
  
  include os
  include wls
  include java
  include nodemanager
  include startwls
  include orawls::weblogic

  Class['os'] ->
    Class['java'] ->
      Class['orawls::weblogic'] ->
        Class['wls'] ->
          Class['nodemanager'] ->
            Class['startwls']
}

# operating settings for Middleware
class os {

  notify { 'class os':} 


  exec { "create swap file":
    command => "/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=8192",
    creates => "/var/swap.1",
  }

  exec { "attach swap file":
    command => "/sbin/mkswap /var/swap.1 && /sbin/swapon /var/swap.1",
    require => Exec["create swap file"],
    unless => "/sbin/swapon -s | grep /var/swap.1",
  }

  group { 'dba' :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  user { 'oracle' :
    ensure     => present,
    groups     => $group,
    shell      => '/bin/bash',
    password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home       => "/home/${user}",
    comment    => 'Oracle user created by Puppet',
    managehome => true,
    require    => Group['dba'],
  }

  class { 'limits':
    config => {
               '*'       => {  'nofile'  => { soft => '2048'   , hard => '8192',   },},
               'oracle'  => {  'nofile'  => { soft => '65536'  , hard => '65536',  },
                               'nproc'   => { soft => '2048'   , hard => '16384',   },
                               'memlock' => { soft => '1048576', hard => '1048576',},
                               'stack'   => { soft => '10240'  ,},},
               },
    use_hiera => false,
  }

  sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
  sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
  sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
  sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
  sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
  sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
  sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
  sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}

}

class java {

  notify { 'class java':} 

  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove:
    ensure  => absent,
  }

  include jdk7

  jdk7::install7{ 'jdk1.7.0_45':
      version              => "7u45" , 
      fullVersion          => "jdk1.7.0_45",
      alternativesPriority => 18000, 
      x64                  => true,
      downloadDir          => "/data/install",
      urandomJavaFix       => true,
      sourcePath           => "/vagrant",
  }

}

class wls{

  notify { 'class wls':} 

#  orawls::domain { 'wlsDomain12c':
#    version                    => 1212,  # 1036|1111|1211|1212
#    weblogic_home_dir          => "/opt/oracle/middleware12c/wlserver",
#    middleware_home_dir        => "/opt/oracle/middleware12c",
#    jdk_home_dir               => "/usr/java/jdk1.7.0_45",
#    domain_template            => "standard",
#    domain_name                => "Wls12c",
#    development_mode           => false,
#    adminserver_name           => "AdminServer",
#    adminserver_address        => "localhost",
#    adminserver_port           => 7001,
#    nodemanager_port           => 5556,
#    weblogic_user              => "weblogic",
#    weblogic_password          => "weblogic1",
#    os_user                    => "oracle",
#    os_group                   => "dba",
#    log_dir                    => "/data/logs",
#    download_dir               => "/data/install",
#    log_output                 => true,
#  }                             
#
   $default = { weblogic_home_dir    => "/opt/oracle/middleware12c/wlserver",
                middleware_home_dir  => "/opt/oracle/middleware12c",
                jdk_home_dir         => "/usr/java/jdk1.7.0_45"
              }
   $domain_instances = hiera('domain_instances', [])
   create_resources('orawls::domain',$domain_instances, $default)

}

class nodemanager {

  # Start the nodemanager
  # in 12c start it after domain creation
#  orawls::nodemanager{'nodemanager12c':
#    version                    => 1212, # 1036|1111|1211|1212
#    weblogic_home_dir          => "/opt/oracle/middleware12c/wlserver",
#    jdk_home_dir               => "/usr/java/jdk1.7.0_45",
#    nodemanager_port           => 5556,
#    domain_name                => "Wls12c",     
#    os_user                    => "oracle",
#    os_group                   => "dba",
#    log_dir                    => "/data/logs",
#    download_dir               => "/data/install",
#    log_output                 => true,
#  }  
#
   $default = { weblogic_home_dir => "/opt/oracle/middleware12c/wlserver",
                jdk_home_dir      => "/usr/java/jdk1.7.0_45"
              }
   $nodemanager_instances = hiera('nodemanager_instances', [])
   create_resources('orawls::nodemanager',$nodemanager_instances, $default)

}

class startwls {

#  # start AdminServer for configuration
#  orawls::control{'startWLSAdminServer12c':
#    domain_name                => "Wls12c",
#    domain_dir                 => "/opt/oracle/middleware12c/user_projects/domains/Wls12c",
#    server_type                => 'admin',  # admin|managed
#    target                     => 'Server', # Server|Cluster
#    server                     => 'AdminServer',
#    action                     => 'start',
#    weblogic_home_dir          => "/opt/oracle/middleware12c/wlserver",
#    jdk_home_dir               => "/usr/java/jdk1.7.0_45",
#    weblogic_user              => "weblogic",
#    weblogic_password          => "weblogic1",
#    adminserver_address        => 'localhost',
#    adminserver_port           => 7001,
#    nodemanager_port           => 5556,
#    os_user                    => "oracle",
#    os_group                   => "dba",
#    log_dir                    => "/data/logs",
#    download_dir               => "/data/install",
#    log_output                 => true,
#  }
#

   $default = { weblogic_home_dir => "/opt/oracle/middleware12c/wlserver",
                jdk_home_dir      => "/usr/java/jdk1.7.0_45"
              }
   $control_instances = hiera('control_instances', [])
   create_resources('orawls::control',$control_instances, $default)

}
