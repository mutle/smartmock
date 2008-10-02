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


def setup_ar
  ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => 'tmp/test.sqlite3'}}
  ActiveRecord::Base.establish_connection
  ActiveRecord::Base.connection.execute "CREATE TABLE IF NOT EXISTS ar_objects (id int, test varchar(255));"
end

def setup_dm
  DataMapper.setup(:default, 'sqlite3::memory:')
  DataMapper.auto_migrate!
end