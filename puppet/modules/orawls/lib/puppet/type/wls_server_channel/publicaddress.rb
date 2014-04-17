newproperty(:publicaddress) do
  include EasyType

  desc "The public address of the server channel"
  defaultto ''


  to_translate_to_resource do | raw_resource|
    raw_resource['publicaddress']
  end

end
