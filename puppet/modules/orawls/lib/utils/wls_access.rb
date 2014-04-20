require 'tempfile'
require 'fileutils'
require 'utils/settings'
#begin
#  require 'ruby-debug'
#  require 'pry'
#rescue LoadError
#  # do nothing 
#end


module Utils
  module WlsAccess

    include Settings

    DEFAULT_FILE = "/etc/wls_setting.yaml"

    def self.included(parent)
      parent.extend(WlsAccess)
    end

    def wlst( content, parameters = {})
           
      script = "wlstScript"
<<<<<<< HEAD
      Puppet.info "Executing: #{script} with parameters #{parameters}"
            
=======
      action = ""
      unless parameters.nil?
        action = parameters["action"] 
        Puppet.info "Executing: #{script} with action #{action}"
      else
        Puppet.info "Executing: #{script} for a create,modify or destroy"
      end      

>>>>>>> master
      tmpFile = Tempfile.new([ script, '.py' ])
      tmpFile.write(content)
      tmpFile.close
      FileUtils.chmod(0555, tmpFile.path)
<<<<<<< HEAD
      
      csv_string = ""
      domains = configuration()

      # if index do all domains
      domains.each { |key, values|
        Puppet.info "domain found #{key}"
        csv_string += execute_wlst( script , tmpFile , parameters,key,values)
      }  
      # else { 
      #  Puppet.info "domain found #{domain}"
      #  csv_string = execute_wlst( script , tmpFile , parameters,domain,domains[domain])
      #}  

      convert_csv_data_to_hash(csv_string, [], :col_sep => ";")
=======

      if action == "index"
        csv_string = execute_wlst( script , tmpFile , parameters, action)
        convert_csv_data_to_hash(csv_string, [], :col_sep => ";")
      else
        execute_wlst( script , tmpFile , parameters , action)
      end 
>>>>>>> master
    end


    private

      def config_file
        Pathname.new(DEFAULT_FILE).expand_path
      end

      def execute_wlst(script, tmpFile, parameters, domain , domainValues)
        
        operatingSystemUser = domainValues['user']              || "oracle"
        weblogicHomeDir     = domainValues['weblogic_home_dir']
        weblogicUser        = domainValues['weblogic_user']     || "weblogic"
        weblogicConnectUrl  = domainValues['connect_url']       || "t3://localhost:7001"
        weblogicPassword    = domainValues['weblogic_password'] || "weblogic1"

<<<<<<< HEAD
        output = `su - #{operatingSystemUser} -c '. #{weblogicHomeDir}/server/bin/setWLSEnv.sh;rm -f /tmp/#{script}.out;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning #{tmpFile.path} #{weblogicUser} #{weblogicPassword} #{weblogicConnectUrl} #{domain}'`
        #Puppet.info "wlst output #{output}"
        raise ArgumentError, "Error executing puppet code, #{output}" if $? != 0
        File.read("/tmp/"+script+".out")
=======
      def execute_wlst(script, tmpFile, parameters,action)
        command = ". #{weblogicHomeDir}/server/bin/setWLSEnv.sh;rm -f /tmp/#{script}.out;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning #{tmpFile.path}"
        output = Puppet::Util::Execution.execute command, :failonfail => true ,:uid => operatingSystemUser
        if action == "index"
          File.read("/tmp/"+script+".out")
        end  
>>>>>>> master
      end
  end
end