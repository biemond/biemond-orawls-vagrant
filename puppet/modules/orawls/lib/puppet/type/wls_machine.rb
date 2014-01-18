require 'easy_type'
require 'utils/wls_access'
require 'facter'

module Puppet
  #
  newtype(:wls_machine) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage machine in an WebLogic domain."

    ensurable

    set_command(:wlst)

    #puppet resource wls_machine --modulepath=/vagrant/puppet/modules --verbose
    #export FACTER_override_weblogic_user=wls
    #export FACTER_override_weblogic_connect_url="t3://10.10.10.10:7001"
    #export FACTER_override_weblogic_adminserver="AdminServer"
    #export FACTER_weblogic_domain="Wls1036"
    #export FACTER_weblogic_domains_path="/opt/oracle/wlsdomains/domains"

    weblogicUser = Facter.value('override_weblogic_user')
    if weblogicUser.nil?
       weblogicUser = "oracle"
    end   
    Puppet.info "oracle operating user: " + weblogicUser

    weblogicConnectUrl = Facter.value('override_weblogic_connect_url')
    if weblogicConnectUrl.nil?
       weblogicConnectUrl = "t3://localhost:7001"
    end   
    Puppet.info "oracle connect url: " + weblogicConnectUrl

    weblogicAdminServer = Facter.value('override_weblogic_adminserver')
    if weblogicAdminServer.nil?
       weblogicAdminServer = "AdminServer"
    end   
    Puppet.info "oracle weblogic adminserver: " + weblogicAdminServer

    weblogicDomain = Facter.value('weblogic_domain')
    fail "weblogicDomain fact is not defined." unless weblogicDomain
    Puppet.info "oracle weblogic domain: " + weblogicDomain

    weblogicDomainsPath = Facter.value('weblogic_domains_path')
    fail "oracle weblogic domains path fact is not defined." unless weblogicDomainsPath
    Puppet.info "oracle weblogic domains path: " + weblogicDomainsPath



    wlstString = <<-eos
connect(url='#{weblogicConnectUrl}',adminServerName='#{weblogicAdminServer}',timeout='5000')

def findServers(machine):
    s = ls('/Servers')
    servers = []
    for token3 in s.split("dr--"):
        token3=token3.strip().lstrip().rstrip()
        if not token3 == '':
          p = ls("/Servers/"+token3+"/Machine")
          for token2 in p.split("drw-"):
            token2=token2.strip().lstrip().rstrip()
            if not token2 == '':
              print "found: "+token2+" match with "+machine
              if str(token2) == str(machine):
                servers.append(token3)
    return servers

m = ls('/Machines')

f = open("/tmp/machines.out", "w")
print >>f, "name:machinetype:nmtype:listenaddress:listenport:servers"
for token in m.split("dr--"):
    token=token.strip().lstrip().rstrip()
    if token:
        print '___'+token+'___'
        machineServers = ""
        machineServers = findServers(token)
        cd('/Machines/'+token)
        type = get('Type')
        cd('NodeManager/'+token)
        print >>f, token+":"+type+":"+get('NMType')+":"+get('ListenAddress')+":"+str(get('ListenPort'))+":["+','.join(machineServers)+"]"

f.close()


disconnect()
exit()
eos
    
    to_get_raw_resources do
      wlst "machines", wlstString, weblogicUser, weblogicDomain, weblogicDomainsPath
    end

    on_create do
      # if self[:password]
      #   "create user #{name} identified by #{self[:password]}"
      # else
      #   "create user #{name}"
      # end
    end

    on_modify do
      # "alter user #{name}"
    end

    on_destroy do
      # "drop user #{name}"
    end

    parameter :name
    property  :machinetype
    property  :nmtype
    property  :listenaddress
    property  :listenport
    property  :servers

  end
end
