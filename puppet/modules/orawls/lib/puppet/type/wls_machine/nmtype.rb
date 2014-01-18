newproperty(:nmtype) do
  include EasyType
  include EasyType::Validators::Name

  desc "The nmtype of the machine"

  to_translate_to_resource do | raw_resource|
    raw_resource['nmtype']
  end

end
