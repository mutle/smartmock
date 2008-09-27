RAILS_ENV='test'

require 'rubygems'
require 'active_record'
require 'dm-core'

require 'lib/smartmock'



class ARObject < ActiveRecord::Base
end

class DMObject
  include DataMapper::Resource
  property :test, String, :key => true
end