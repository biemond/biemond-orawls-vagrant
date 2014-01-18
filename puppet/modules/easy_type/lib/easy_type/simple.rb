require 'utils/easy_type'

Puppet::Type.type(:easy_type).provide(:simple) do
  include ::Utils::EasyType

  desc "A default simple resource provider"

  mk_resource_methods

end