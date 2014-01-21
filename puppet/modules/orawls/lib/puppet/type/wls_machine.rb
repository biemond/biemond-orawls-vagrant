require 'easy_type'
require 'utils/wls_access'
require 'utils/erb_reader'
require 'facter'

module Puppet
  #
  newtype(:wls_machine) do
    include EasyType
    include Utils::WlsAccess
    extend Utils::ERBReader


    desc "This resource allows you to manage machine in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      wlst erb_template('providers/wls_machine/index.py', binding)
    end

    on_create do
      extend Utils::ERBReader
      Puppet.info "create #{name} "
      erb_template('providers/wls_machine/create.py', binding)
    end

    on_modify do
      extend Utils::ERBReader
      Puppet.info "modify #{name} "
      erb_template('providers/wls_machine/modify.py', binding)
    end

    on_destroy do
      extend Utils::ERBReader
      Puppet.info "destroy #{name} "
      erb_template('providers/wls_machine/destroy.py', binding)
    end

    parameter :name
    property  :machinetype
    property  :nmtype
    property  :listenaddress
    property  :listenport
#    property  :servers

  private 

    def listenaddress
      self[:listenaddress]
    end

    def listenport
      self[:listenport]
    end

    def machinetype
      self[:machinetype]
    end

    def nmtype
      self[:nmtype]
    end


  end
end
