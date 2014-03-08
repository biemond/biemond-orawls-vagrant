newproperty(:distributed) do
  include EasyType
  include EasyType::Validators::Name

  desc "Distributed queue"
  newvalues(1, 0)

  to_translate_to_resource do | raw_resource|
    raw_resource['distributed']
  end

end
