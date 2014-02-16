newproperty(:admin_server) do
  include EasyType

  desc "the host name of the admin server"
  defaultto 'AdminServer'

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
