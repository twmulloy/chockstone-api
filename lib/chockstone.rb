module Chockstone

  require 'rubygems'
  require 'active_support/core_ext/hash/conversions'

  # use 'libxml' if having namespace issues
  # using 'xml' allows us to use XML:: instead of LibXML::XML::
  require 'xml'
  require 'net/https'


  $:.unshift(File.dirname(__FILE__))
  require 'chockstone/connection'

end