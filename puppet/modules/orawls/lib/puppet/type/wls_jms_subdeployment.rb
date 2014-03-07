require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_subdeployment) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a JMS subdeployment in a JMS module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_jms_subdeployment/index.py.erb', binding)
      Puppet.info "finish #{name} "
    end

    on_create do
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_subdeployment/create.py.erb', binding)
    end

    on_modify do
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_subdeployment/modify.py.erb', binding)
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_subdeployment/destroy.py.erb', binding)
    end

    parameter :name
    property  :jmsmodule

  private 

    def jmsmodule
      self[:jmsmodule]
    end

  end
end
