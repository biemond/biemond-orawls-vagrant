newproperty(:applicationname) do
  include EasyType

  desc "The application name"

  to_translate_to_resource do | raw_resource|
    raw_resource['applicationname']
  end

end