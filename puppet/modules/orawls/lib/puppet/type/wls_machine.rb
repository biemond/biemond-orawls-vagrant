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

    wlstString = <<-eos
connect(url='#{weblogicConnectUrl}',adminServerName='#{weblogicAdminServer}',timeout='5000')

# def findServers(machine):
#     s = ls('/Servers')
#     servers = []
#     for token3 in s.split("dr--"):
#         token3=token3.strip().lstrip().rstrip()
#         if not token3 == '':
#           p = ls("/Servers/"+token3+"/Machine")
#           for token2 in p.split("drw-"):
#             token2=token2.strip().lstrip().rstrip()
#             if not token2 == '':
#               print "found: "+token2+" match with "+machine
#               if str(token2) == str(machine):
#                 servers.append(token3)
#     return servers

m = ls('/Machines')

f = open("/tmp/wlstScript.out", "w")
print >>f, "name:machinetype:nmtype:listenaddress:listenport:servers"
for token in m.split("dr--"):
    token=token.strip().lstrip().rstrip()
    if token:
        print '___'+token+'___'
        # machineServers = ""
        # machineServers = findServers(token)
        cd('/Machines/'+token)
        type = get('Type')
        cd('NodeManager/'+token)
        print >>f, token+":"+type+":"+get('NMType')+":"+get('ListenAddress')+":"+str(get('ListenPort'))
        #+','.join(machineServers)

f.close()


disconnect()
exit()
eos
  
    to_get_raw_resources do
      wlst wlstString
    end

    on_create do
      Puppet.info "create #{name} "
      createWLSTstring = <<-eos
connect(url='#{weblogicConnectUrl}',adminServerName='#{weblogicAdminServer}',timeout='5000')

machineName    = '#{self[:name]}'
machineDnsName = '#{self[:listenaddress]}'
portNumber     =  #{self[:listenport]}
machineType    = '#{self[:machinetype]}'
nmType         = '#{self[:nmtype]}'

edit()
startEdit()

try:
    f = open("/tmp/wlstScript.out", "w")
    cd('/')
    if machineType == 'UnixMachine':
      cmo.createUnixMachine(machineName)
    else:
      cmo.createMachine(machineName)

    cd('/Machines/'+machineName+'/NodeManager/'+machineName)
    cmo.setNMType(nmType)
    cmo.setListenAddress(machineDnsName)
    cmo.setListenPort(portNumber)

    f.close()

    save()
    activate()

except:
    print "Unexpected error:", sys.exc_info()[0]
    undo('true','y')
    stopEdit('y')
    raise

disconnect()
exit()
eos
    end

    on_modify do
      Puppet.info "modify #{name} "
      modifyWLSTstring = <<-eos
connect(url='#{weblogicConnectUrl}',adminServerName='#{weblogicAdminServer}',timeout='5000')

machineName    = '#{self[:name]}'
machineDnsName = '#{self[:listenaddress]}'
portNumber     =  #{self[:listenport]}
machineType    = '#{self[:machinetype]}'
nmType         = '#{self[:nmtype]}'

edit()
startEdit()

try:
    f = open("/tmp/wlstScript.out", "w")

    cd('/Machines/'+machineName+'/NodeManager/'+machineName)
    cmo.setNMType(nmType)
    cmo.setListenAddress(machineDnsName)
    cmo.setListenPort(portNumber)

    f.close()
    save()
    activate()

except:
    print "Unexpected error:", sys.exc_info()[0]
    undo('true','y')
    stopEdit('y')
    raise

disconnect()
exit()
eos
    end

    on_destroy do
      Puppet.info "destroy #{name} "
      deleteWLSTstring = <<-eos
connect(url='#{weblogicConnectUrl}',adminServerName='#{weblogicAdminServer}',timeout='5000')

machineName = '#{self[:name]}'

edit()
startEdit()

try:
    f = open("/tmp/wlstScript.out", "w")

    editService.getConfigurationManager().removeReferencesToBean(getMBean('/Machines/'+machineName))
    cd('/')
    cmo.destroyMachine(getMBean('/Machines/'+machineName))

    f.close()
    save()
    activate()

except:
    print "Unexpected error:", sys.exc_info()[0]
    undo('true','y')
    stopEdit('y')
    raise

disconnect()
exit()
eos
    end

    parameter :name
    property  :machinetype
    property  :nmtype
    property  :listenaddress
    property  :listenport
#    property  :servers

  end
end
