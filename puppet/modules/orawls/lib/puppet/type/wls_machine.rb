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

    #puppet resource wls_machine --modulepath=/vagrant/puppet/modules --verbose
    #export FACTER_override_weblogic_user=wls
    #export FACTER_override_weblogic_connect_url="t3://10.10.10.10:7001"
    #export FACTER_override_weblogic_adminserver="AdminServer"
    #export FACTER_weblogic_domain="Wls1036"
    #export FACTER_weblogic_domains_path="/opt/oracle/wlsdomains/domains"
  
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

    def weblogicConnectUrl
      Facter.value('override_weblogic_connect_url') || "t3://localhost:7001"
    end

    def weblogicAdminServer
      Facter.value('override_weblogic_adminserver') || "AdminServer"
    end

  end
end
