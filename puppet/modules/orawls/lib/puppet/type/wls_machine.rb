require 'easy_type'
require 'utils/wls_access'
require 'utils/erb_reader'
require 'facter'

module Puppet
  #
  newtype(:wls_machine) do
    include EasyType
    include Utils::WlsAccess
    include Utils::ERBReader


    desc "This resource allows you to manage machine in an WebLogic domain."

    Puppet.info "oracle weblogic adminserver: #{weblogicAdminServer}"
    Puppet.info "oracle connect url: #{weblogicConnectUrl}"

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      wlst erb_template('index.py', binding)
    end


    on_create do
      Puppet.info "create #{name} "
      erb_template('create.py', binding)
    end

    on_modify do
      Puppet.info "modify #{name} "
      erb_template('modify.py', binding)
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      erb_template('destroy.py', binding)
    end

    parameter :name
    property  :machinetype
    property  :nmtype
    property  :listenaddress
    property  :listenport
#    property  :servers

  private


  end
end
