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
