require 'tempfile'
require 'fileutils'
require 'csv'
#begin
#  require 'ruby-debug'
#  require 'pry'
#rescue LoadError
#  # do nothing 
#end


module Utils
  module WlsAccess

    DEFAULT_FILE = "~/.wls_setting.yaml"

    def self.included(parent)
      parent.extend(WlsAccess)
      parent.extend(Settings)
    end

    def wlst( content, parameters = {})
           
      script = "wlstScript"

      Puppet.info "Executing: #{script}"

            
      tmpFile = Tempfile.new([ script, '.py' ])
      tmpFile.write(content)
      tmpFile.close
      FileUtils.chmod(0555, tmpFile.path)
      csv_string = execute_wlst( script , tmpFile , parameters)
      convert_csv_data_to_hash(csv_string, [], :column_delimeter => ";")
    end


    private

      def config_file
        Pathname.new(DEFAULT_FILE).expand_path
      end

      def weblogicUser
        setting_for('user') || "oracle"
      end

      def weblogicDomain
        setting_for('domain')
      end

      def weblogicDomainsPath
        setting_for('domains_path')
      end

      def weblogicConnectUrl
        setting_for('connect_url') || "t3://localhost:7001"
      end

      def weblogicAdminServer
        setting_for('adminserver') || "AdminServer"
      end

      def execute_wlst(script, tmpFile, parameters)
        output = `su - #{weblogicUser} -c '. #{weblogicDomainsPath}/#{weblogicDomain}/bin/setDomainEnv.sh;rm -f /tmp/#{script}.out;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning #{tmpFile.path}'`
        raise ArgumentError, "Error executing puppet code, #{output}" if $? != 0
        File.read("/tmp/"+script+".out")
      end
  end
end