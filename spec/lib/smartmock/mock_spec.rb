require File.join(File.dirname(__FILE__), '../../spec_helper.rb')

describe Smartmock::Mock do
  
  context "ActiveRecord" do
    
    before :each do
      ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => 'tmp/test.sqlite3'}}
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.execute "CREATE TABLE IF NOT EXISTS ar_objects (id int, test varchar(255));"
    end
    
    it "should mock a AR object" do      
      obj = ARObject.create(:test => 'test')
      obj.test.should == 'test'
      
      obj2 = Smartmock[ARObject].new(:test => 'test2')
      obj2.test.should == 'test2'
      lambda { obj2.test2 }.should raise_error(NameError)
    end
    
    it "should be dirty if not saved" do
      obj2 = Smartmock[ARObject].new(:test => 'test2')
      obj2.test.should == 'test2'
      obj2.should be_dirty
      obj2.save
      obj2.should_not be_dirty
    end
    
  end
  
  
  context "DataMapper" do
    
    before :all do
      DataMapper.setup(:default, 'sqlite3::memory:')
      DataMapper.auto_migrate!
    end
    
    it "should mock a DM object" do
      obj = DMObject.create(:test => 'test')
      obj.test.should == 'test'
      
      obj2 = Smartmock[DMObject].new(:test => 'test2')
      obj2.test.should == 'test2'
      lambda { obj2.test2 }.should raise_error(NameError)
    end
    
  end
  
end

describe Object, "#smartmock_next" do
  
  it "should return a smartmock on the next call to new" do
    smartmock_next(ARObject)
    obj = ARObject.new(:test => 'test')
    obj.class.name.should == "Smartmock::Mock"
    
    obj = ARObject.new(:test => 'test')
    obj.class.name.should == "ARObject"
  end
  
  it "should stub additional methods" do
    smartmock_next(ARObject, :test_stub => 'test')
    obj = ARObject.new
    obj.class.name.should == "Smartmock::Mock"
    obj.test_stub.should == "test"
  end
  
  it "should store a reference to the last smartmock" do
    smartmock_next(ARObject)
    obj = ARObject.new(:test => 'test')
    ARObject.last_smartmock.should == obj
    ARObject.last_smartmock.test.should == 'test'
  end
  
end