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
      action = ""
      unless parameters.nil?
        action = parameters["action"] 
        Puppet.info "Executing: #{script} with action #{action}"
      else
        Puppet.info "Executing: #{script} for a create,modify or destroy"
      end      

      tmpFile = Tempfile.new([ script, '.py' ])
      tmpFile.write(content)
      tmpFile.close
      FileUtils.chmod(0555, tmpFile.path)
      
      csv_string = ""
      domains = configuration()

      if action == "index"
        # if index do all domains
        domains.each { |key, values|
          Puppet.info "domain found #{key}"
          csv_string += execute_wlst( script , tmpFile , parameters,key,values, action)
        }  
        convert_csv_data_to_hash(csv_string, [], :col_sep => ";")
      else
        #  Puppet.info "domain found #{domain}"
        domains.each { |key, values|
          Puppet.info "domain found #{key}"
          execute_wlst( script , tmpFile , parameters,key,values, action)
        }  
      end 
    end


    private

      def config_file
        Pathname.new(DEFAULT_FILE).expand_path
      end

      def execute_wlst(script, tmpFile, parameters, domain , domainValues, action)
        
        operatingSystemUser = domainValues['user']              || "oracle"
        weblogicHomeDir     = domainValues['weblogic_home_dir']
        weblogicUser        = domainValues['weblogic_user']     || "weblogic"
        weblogicConnectUrl  = domainValues['connect_url']       || "t3://localhost:7001"
        weblogicPassword    = domainValues['weblogic_password'] || "weblogic1"

        command = ". #{weblogicHomeDir}/server/bin/setWLSEnv.sh;rm -f /tmp/#{script}.out;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning #{tmpFile.path} #{weblogicUser} #{weblogicPassword} #{weblogicConnectUrl} #{domain}"
        output = Puppet::Util::Execution.execute command, :failonfail => true ,:uid => operatingSystemUser
        if action == "index"
          File.read("/tmp/"+script+".out")
        end  
      end
  end
end