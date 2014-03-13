# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "admin" , primary: true do |admin|
    admin.vm.box = "centos-6.5-x86_64"
    #admin.vm.box_url ="/Users/edwin/projects/packer-vagrant-builder/build/centos-6.5-x86_64.box"
    admin.vm.box_url = "https://dl.dropboxusercontent.com/s/np39xdpw05wfmv4/centos-6.5-x86_64.box"

    admin.vm.hostname = "admin.example.com"
    admin.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    admin.vm.synced_folder "/Users/edwin/software", "/software"

    #admin.vm.synced_folder ".", "/vagrant", type: "nfs"
    #admin.vm.synced_folder "/Users/edwin/software", "/software", type: "nfs"

    admin.vm.network :private_network, ip: "10.10.10.10"
  
    admin.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--name", "admin"]
    end
  
    admin.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml;rm -rf /etc/puppet/modules;ln -sf /vagrant/puppet/modules /etc/puppet/modules"
    
    admin.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "site.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment"                     => "development",
        "vm_type"                         => "vagrant",
        "override_weblogic_user"          => "wls",
      }
      
    end
  
  end
  
  config.vm.define "node1" do |node1|

    node1.vm.box = "centos-6.5-x86_64"
    #node1.vm.box_url ="/Users/edwin/Downloads/centos-6.5-x86_64.box"
    node1.vm.box_url = "https://dl.dropboxusercontent.com/s/np39xdpw05wfmv4/centos-6.5-x86_64.box"
  
    node1.vm.hostname = "node1.example.com"
    node1.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    node1.vm.synced_folder "/Users/edwin/software", "/software"
    #node1.vm.synced_folder ".", "/vagrant", type: "nfs"
    #node1.vm.synced_folder "/Users/edwin/software", "/software", type: "nfs"



    node1.vm.network :private_network, ip: "10.10.10.100"
  
    node1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1532"]
      vb.customize ["modifyvm", :id, "--name", "node1"]
    end
  
    node1.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml;rm -rf /etc/puppet/modules;ln -sf /vagrant/puppet/modules /etc/puppet/modules"
    
    node1.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment"                     => "development",
        "vm_type"                         => "vagrant",
        "override_weblogic_user"          => "wls",
      }
      
    end

  end

  config.vm.define "node2" do |node2|

    node2.vm.box = "centos-6.5-x86_64"
    #node2.vm.box_url ="/Users/edwin/Downloads/centos-6.5-x86_64.box"
    node2.vm.box_url = "https://dl.dropboxusercontent.com/s/np39xdpw05wfmv4/centos-6.5-x86_64.box"

    node2.vm.hostname = "node2.example.com"
    node2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
    node2.vm.synced_folder "/Users/edwin/software", "/software"

    #node2.vm.synced_folder ".", "/vagrant", type: "nfs"
    #node2.vm.synced_folder "/Users/edwin/software", "/software", type: "nfs"


    node2.vm.network :private_network, ip: "10.10.10.200", auto_correct: true
  
    node2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1532"]
      vb.customize ["modifyvm", :id, "--name", "node2"]
    end
  
    node2.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml;rm -rf /etc/puppet/modules;ln -sf /vagrant/puppet/modules /etc/puppet/modules"
    
    node2.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --parser future --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment"                     => "development",
        "vm_type"                         => "vagrant",
        "override_weblogic_user"          => "wls",
      }
      
    end

  end


end
