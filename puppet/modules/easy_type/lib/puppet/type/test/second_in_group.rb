newproperty(:second_in_group) do
	include EasyType

  on_apply do | builder| 
    "second in group"
  end
end
