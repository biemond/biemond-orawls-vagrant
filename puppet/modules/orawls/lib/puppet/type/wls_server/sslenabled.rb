newproperty(:sslenabled) do
  include EasyType
  include EasyType::Validators::Name

  desc "The ssl enabled on the server"

  to_translate_to_resource do | raw_resource|
    raw_resource['sslenabled']
  end

end
