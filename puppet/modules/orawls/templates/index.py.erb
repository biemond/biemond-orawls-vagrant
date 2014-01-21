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
