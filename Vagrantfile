# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "admin" , primary: true do |admin|
    admin.vm.box = "centos64-432r90405"
    #admin.vm.box_url = "https://dl.dropboxusercontent.com/u/97268835/boxes/centos64.box"
    admin.vm.box_url = "https://dl.dropboxusercontent.com/s/09fvyojquq615ai/centos64-432r90405.box"

    admin.vm.hostname = "admin.example.com"
    # admin.vm.network :forwarded_port, guest: 80, host: 8888 ,auto_correct: true
    # admin.vm.network :forwarded_port, guest: 7001, host: 7001, auto_correct: true
  
    admin.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
    admin.vm.network :private_network, ip: "10.10.10.10"
  
    # admin.vm.network :public_network
    # admin.ssh.forward_agent = true
    # admin.vm.synced_folder "../data", "/vagrant_data"
  
    admin.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--name", "admin"]
    end
  
    admin.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    admin.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "site.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
      }
      
    end
  
  end
  
  config.vm.define "node1" do |node1|
    node1.vm.box = "centos64-432r90405"
    #node1.vm.box_url = "https://dl.dropboxusercontent.com/u/97268835/boxes/centos64.box"
    node1.vm.box_url = "https://dl.dropboxusercontent.com/s/09fvyojquq615ai/centos64-432r90405.box"
  
    node1.vm.hostname = "node1.example.com"
    #node1.vm.network :forwarded_port, guest: 8002, host: 8002, auto_correct: true
  
    node1.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
    node1.vm.network :private_network, ip: "10.10.10.100"
  
    # node1.vm.network :public_network
    # node1.ssh.forward_agent = true
    # node1.vm.synced_folder "../data", "/vagrant_data"
  
    node1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1532"]
      vb.customize ["modifyvm", :id, "--name", "node1"]
    end
  
    node1.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    node1.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
      }
      
    end

  end

  config.vm.define "node2" do |node2|
    node2.vm.box = "centos64-432r90405"
    #node2.vm.box_url = "https://dl.dropboxusercontent.com/u/97268835/boxes/centos64.box"
    node2.vm.box_url = "https://dl.dropboxusercontent.com/s/09fvyojquq615ai/centos64-432r90405.box"
  
    node2.vm.hostname = "node2.example.com"
    #node2.vm.network :forwarded_port, guest: 8001, host: 8001
  
    node2.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]
  
    node2.vm.network :private_network, ip: "10.10.10.200", auto_correct: true
  
    # node2.vm.network :public_network
    # node2.ssh.forward_agent = true
    # node2.vm.synced_folder "../data", "/vagrant_data"
  
    node2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1532"]
      vb.customize ["modifyvm", :id, "--name", "node2"]
    end
  
    node2.vm.provision :shell, :inline => "ln -sf /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml"
    
    node2.vm.provision :puppet do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.module_path       = "puppet/modules"
      puppet.manifest_file     = "node.pp"
      puppet.options           = "--verbose --hiera_config /vagrant/puppet/hiera.yaml"
  
      puppet.facter = {
        "environment" => "development",
        "vm_type"     => "vagrant",
      }
      
    end

  end


end
