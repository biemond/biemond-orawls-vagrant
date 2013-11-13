# test
#
# one machine setup with weblogic 12.1.2
# creates an WLS Domain with JAX-WS (advanced, soap over jms)
# needs jdk7, orawls, orautils, fiddyspence-sysctl, erwbgy-limits puppet modules
#

node 'admin.example.com' {
  
  include os,ssh,java,orawls::weblogic,orautils
  include bsu,fmw
  include domains,nodemanager,startwls,userconfig
  include machines,managed_servers,clusters
  include jms_servers,file_persistences,jms_modules,jms_module_subdeployments
  include jms_module_quotas,jms_module_cfs,jms_module_objects_errors,jms_module_objects
  include pack_domain

  Class['os'] ->
    Class['ssh'] ->
      Class['java'] ->
        Class['orawls::weblogic'] ->
          Class['bsu'] ->
            Class['fmw'] ->
              Class['domains'] ->
                Class['nodemanager'] ->
                  Class['startwls'] ->
                    Class['userconfig'] ->
                      Class['machines'] ->
                        Class['managed_servers'] ->
                          Class['clusters'] ->
                            Class['file_persistences'] ->
                              Class['jms_servers'] ->
                                Class['jms_modules'] ->
                                  Class['jms_module_subdeployments'] ->
                                    Class['jms_module_quotas'] ->
                                      Class['jms_module_cfs'] ->
                                        Class['jms_module_objects_errors'] ->
                                          Class['jms_module_objects'] ->
                                            Class['pack_domain']
}



# operating settings for Middleware
class os {

  notify { "class os ${operatingsystem}":} 

  host{"node1":
    ip => "10.10.10.100",
    host_aliases => ['node1.example.com','node1'],
  }

  host{"node2":
    ip => "10.10.10.200",
    host_aliases => ['node2.example.com','node2'],
  }

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
    groups     => 'dba',
    shell      => '/bin/bash',
    password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home       => "/home/oracle",
    comment    => 'Oracle user created by Puppet',
    managehome => true,
    require    => Group['dba'],
  }

  $install = [ 'binutils.x86_64','unzip.x86_64']


  package { $install:
    ensure  => present,
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

class ssh {

  notify { 'class ssh':} 

  file { "/home/oracle/.ssh/":
    owner  => "oracle",
    group  => "dba",
    mode   => "700",
    ensure => "directory",
    alias  => "oracle-ssh-dir",
  }
  
  file { "/home/oracle/.ssh/id_rsa.pub":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "644",
    source  => "/vagrant/ssh/id_rsa.pub",
    require => File["oracle-ssh-dir"],
  }
  
  file { "/home/oracle/.ssh/id_rsa":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "600",
    source  => "/vagrant/ssh/id_rsa",
    require => File["oracle-ssh-dir"],
  }
  
  file { "/home/oracle/.ssh/authorized_keys":
    ensure  => present,
    owner   => "oracle",
    group   => "dba",
    mode    => "644",
    source  => "/vagrant/ssh/id_rsa.pub",
    require => File["oracle-ssh-dir"],
  }        
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


class bsu{

  notify { 'class bsu':} 
  $default_params = {}
  $bsu_instances = hiera('bsu_instances', [])
  create_resources('orawls::bsu',$bsu_instances, $default_params)
}

class fmw{

  notify { 'class fmw':} 
  $default_params = {}
  $fmw_installations = hiera('fmw_installations', [])
  create_resources('orawls::fmw',$fmw_installations, $default_params)
}

class domains{

  notify { 'class wls':} 
  $default_params = {}
  $domain_instances = hiera('domain_instances', [])
  create_resources('orawls::domain',$domain_instances, $default_params)
}

class nodemanager {

  notify { 'class nodemanager':} 
  $default_params = {}
  $nodemanager_instances = hiera('nodemanager_instances', [])
  create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
}

class startwls {

  notify { 'class startwls':} 
  $default_params = {}
  $control_instances = hiera('control_instances', [])
  create_resources('orawls::control',$control_instances, $default_params)
}

class userconfig{

  notify { 'class userconfig':} 
  $default_params = {}
  $userconfig_instances = hiera('userconfig_instances', [])
  create_resources('orawls::storeuserconfig',$userconfig_instances, $default_params)
}	

class machines{

  notify { 'class machines':} 
  $default_params = {}
  $machines_instances = hiera('machines_instances', [])
  create_resources('orawls::wlstexec',$machines_instances, $default_params)
}

class managed_servers{

  notify { 'class managed_servers':} 
  $default_params = {}
  $managed_servers_instances = hiera('managed_servers_instances', [])
  create_resources('orawls::wlstexec',$managed_servers_instances, $default_params)
}

class clusters{

  notify { 'class clusters':} 
  $default_params = {}
  $cluster_instances = hiera('cluster_instances', [])
  create_resources('orawls::wlstexec',$cluster_instances, $default_params)
}

class file_persistences {

  notify { 'class file_persistences':} 
  $default_params = {}
  $file_persistence_instances = hiera('file_persistence_instances', [])
  create_resources('orawls::wlstexec',$file_persistence_instances, $default_params)

}

class jms_servers{

  notify { 'class jms_servers':} 
  $default_params = {}
  $jms_servers_instances = hiera('jms_servers_instances', [])
  create_resources('orawls::wlstexec',$jms_servers_instances, $default_params)

}

class jms_modules{

  notify { 'class jms_modules':} 
  $default_params = {}
  $jms_module_instances = hiera('jms_module_instances', [])
  create_resources('orawls::wlstexec',$jms_module_instances, $default_params)

}

class jms_module_subdeployments{

  notify { 'class jms_module_subdeployments':} 
  $default_params = {}
  $jms_module_subdeployments_instances = hiera('jms_module_subdeployments_instances', [])
  create_resources('orawls::wlstexec',$jms_module_subdeployments_instances, $default_params)

}
class jms_module_quotas{

  notify { 'class jms_module_quotas':} 
  $default_params = {}
  $jms_module_quotas_instances = hiera('jms_module_quotas_instances', [])
  create_resources('orawls::wlstexec',$jms_module_quotas_instances, $default_params)

}

class jms_module_cfs{

  notify { 'class jms_module_cfs':} 
  $default_params = {}
  $jms_module_cf_instances = hiera('jms_module_cf_instances', [])
  create_resources('orawls::wlstexec',$jms_module_cf_instances, $default_params)

}

class jms_module_objects_errors{

  notify { 'class jms_module_objects_errors':} 
  $default_params = {}
  $jms_module_jms_errors_instances = hiera('jms_module_jms_errors_instances', [])
  create_resources('orawls::wlstexec',$jms_module_jms_errors_instances, $default_params)

}


class jms_module_objects{

  notify { 'class jms_module_objects':} 
  $default_params = {}
  $jms_module_jms_instances = hiera('jms_module_jms_instances', [])
  create_resources('orawls::wlstexec',$jms_module_jms_instances, $default_params)

}

class pack_domain{

  notify { 'class pack_domain':} 
  $default_params = {}
  $pack_domain_instances = hiera('pack_domain_instances', [])
  create_resources('orawls::packdomain',$pack_domain_instances, $default_params)

	
}