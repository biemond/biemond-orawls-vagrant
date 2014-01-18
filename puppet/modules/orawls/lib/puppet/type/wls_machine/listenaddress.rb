newproperty(:listenaddress) do
  include EasyType
  include EasyType::Validators::Name

  desc "The listenaddress of the machine"

  to_translate_to_resource do | raw_resource|
    raw_resource['listenaddress']
  end

end
