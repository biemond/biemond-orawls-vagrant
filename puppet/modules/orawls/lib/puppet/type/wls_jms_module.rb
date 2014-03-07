require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_module) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a JMS module in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_jms_module/index.py.erb', binding)
      Puppet.info "finish #{name} "
    end

    on_create do
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_module/create.py.erb', binding)
    end

    on_modify do
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_module/modify.py.erb', binding)
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_module/destroy.py.erb', binding)
    end

    parameter :name
    property  :servers
    property  :migrationbasis
    property  :messagingmode

  private 

    def servers
      self[:servers]
    end

    def migrationbasis
      self[:migrationbasis]
    end

    def messagingmode
      self[:messagingmode]
    end

  end
end
