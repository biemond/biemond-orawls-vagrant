require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_queue) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a Queue in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      wlst template('puppet:///modules/orawls/providers/wls_jms_queue/index.py.erb', binding)
    end

    on_create do
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_queue/create.py.erb', binding)
    end

    on_modify do
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_queue/modify.py.erb', binding)
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_queue/destroy.py.erb', binding)
    end

    def self.title_patterns
      identity = lambda {|x| x}
      [
        [
          /^(.*):(.*)$/,
          [
            [ :jmsmodule, identity ],
            [ :name     , identity ]
          ]
        ]
      ]
    end

    parameter :name
    parameter :jmsmodule
    property  :distributed
    property  :jndiname
    property  :subdeployment

  private 

    def name
       self[:name]
    end

    def jmsmodule
       self[:jmsmodule]
    end

    def distributed
       self[:distributed]
    end

    def jndiname
       self[:jndiname]
    end

    def subdeployment
       self[:subdeployment]
    end

  end
end
