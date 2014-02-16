newproperty(:domain) do
  include EasyType

  desc "The WLS domain"

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
