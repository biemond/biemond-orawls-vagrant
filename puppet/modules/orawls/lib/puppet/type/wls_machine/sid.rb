newmetaparam(:sid) do
  include EasyType

  desc "The machine name"

  to_translate_to_resource do | raw_resource|
    raw_resource['name']
  end

end
