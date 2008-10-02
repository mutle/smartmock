require File.join(File.dirname(__FILE__), '../../spec_helper.rb')

describe Object, "#smartmock_next" do
  
  before :all do
    setup_ar
  end
  
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

describe Object, "#smartmock_insert" do
  
  context "ActiveRecord" do
    
    before :all do
      setup_ar
    end
    
  end
  
  context "DataMapper" do
    
    before :all do
      setup_dm
    end
    
    it "should insert a smartmock and return it when it's searched for" do
      smartmock_insert(mock = Smartmock[DMObject].new(:id => 1))
      DMObject.get(1).should == mock
      DMObject.get(1).should == nil
    end
    
    it "should insert a smartmock and return it when it's searched for with get!" do
      smartmock_insert(mock = Smartmock[DMObject].new(:id => 1))
      DMObject.get!(1).should == mock
      smartmock_insert(mock)
      lambda { DMObject.get!(2) }.should raise_error(DataMapper::ObjectNotFoundError)
      lambda { DMObject.get!(1) }.should raise_error(DataMapper::ObjectNotFoundError)
    end
    
  end
  
end