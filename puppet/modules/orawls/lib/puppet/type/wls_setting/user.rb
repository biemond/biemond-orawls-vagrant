newproperty(:user) do
  include EasyType

  desc "TODO: Fill in the description"

  to_translate_to_resource do | raw_resource|
    raw_resource[self.name]
  end

end
