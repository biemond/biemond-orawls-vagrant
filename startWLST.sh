PATH=/usr/java/jdk1.7.0_45/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin
JAVA_HOME=/usr/java/jdk1.7.0_45
MDW_HOME=/opt/oracle/middleware11g/wlserver_10.3
CLASSPATH=$MDW_HOME/server/lib/weblogic.jar

export PATH JAVA_HOME MDW_HOME CLASSPATH

java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning