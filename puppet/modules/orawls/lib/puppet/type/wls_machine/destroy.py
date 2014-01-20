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
