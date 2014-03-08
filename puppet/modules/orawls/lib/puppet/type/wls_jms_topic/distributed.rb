newproperty(:distributed) do
  include EasyType
  include EasyType::Validators::Name

  desc "Distributed topic"
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['distributed']
  end

end
