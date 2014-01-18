newproperty(:servers) do
  include EasyType
  include EasyType::Validators::Name

  desc "The assigned targets of the machine"

  to_translate_to_resource do | raw_resource|
    raw_resource['servers']
  end

end
