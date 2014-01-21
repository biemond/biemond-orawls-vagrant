require 'tempfile'
require 'fileutils'
require 'csv'
require 'utils/erb_reader'
begin
	require 'ruby-debug'
	require 'pry'
rescue LoadError
	# do nothing 
end


module Utils
	module WlsAccess
	  	

		class QueryResults < Hash
			def column_data(column_name)
				fetch(column_name) do 
					fail "Column #{column_name} not found in results. Results contain #{keys.join(',')}"
				end
			end
		end


		def self.included(parent)
			parent.extend(WlsAccess)
		end

		def wlst( content, parameters = {})
           
		    script = "wlstScript"

			Puppet.info "Executing: #{script}"
		    Puppet.info "oracle operating user: " + weblogicUser
	        fail "weblogicDomain fact is not defined." unless weblogicDomain
	        Puppet.info "oracle weblogic domain: " + weblogicDomain

            weblogicDomainsPath = Facter.value('weblogic_domains_path')
            fail "oracle weblogic domains path fact is not defined." unless weblogicDomainsPath
            Puppet.info "oracle weblogic domains path: " + weblogicDomainsPath
            
			tmpFile = Tempfile.new([ script, '.py' ])
			tmpFile.write(content)
			tmpFile.close
			FileUtils.chmod(0555, tmpFile.path)

			csv_string = execute_wlst( script , tmpFile , weblogicUser, weblogicDomain, weblogicDomainsPath, parameters)
			convert_csv_data_to_hash(csv_string)
		end


		private

		def weblogicUser
			Facter.value('override_weblogic_user') || "oracle"
		end

		def weblogicDomain
        	Facter.value('weblogic_domain')
        end

        def weblogicDomainsPath
        	Facter.value('weblogic_domains_path')
    	end

		def weblogicConnectUrl
		  Facter.value('override_weblogic_connect_url') || "t3://localhost:7001"
		end

		def weblogicAdminServer
		  Facter.value('override_weblogic_adminserver') || "AdminServer"
		end


		def execute_wlst(script, tmpFile, user, domain, domainpath, parameters)
            Puppet.info  "su - #{user} -c '. #{domainpath}/#{domain}/bin/setDomainEnv.sh;java weblogic.WLST #{tmpFile.path}'"		
			output = `su - #{user} -c '. #{domainpath}/#{domain}/bin/setDomainEnv.sh;rm -f /tmp/#{script}.out;java -Dweblogic.security.SSL.ignoreHostnameVerification=true weblogic.WLST -skipWLSModuleScanning #{tmpFile.path}'`
			raise ArgumentError, "Error executing puppet code, #{output}" if $? != 0
			File.read("/tmp/"+script+".out")
		end

		def convert_csv_data_to_hash(csv_data)
			data = []
			headers = []

			csv_data.split("\n").each do | row |
				columnized = row.split(':')
				columnized.map!{|column| column.strip}
				if headers.empty?
					headers = columnized
				else
					values = headers.zip(columnized)
					data << QueryResults[values]
				end
			end
			data
		end

	end
end