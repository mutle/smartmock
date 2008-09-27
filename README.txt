= Smartmock

== What is Smartmock?

Don't you hate how dumb your Model Mocks are sometimes? Little changes to your implementation can break your specs, as mocking forces you to test your implementation and not the results.

Well, no more.

Smartmock lets you focus on the results of your code instead of the implementation.

Plus it works with ActiveRecord as well as DataMapper.

== Status

Development of Smartmock just got started, and a lot is still missing. If you want to contribute, feel free to fork Smartmock on GitHub (<http://gitub.com/mutle/smartmock>) and send a pull request.

== Examples

To demonstrate, here is some code that shows the usage of Smartmock in a Merb Controller spec.

With Smartmock:
  
  describe Users, "create action" do
    before(:each) do
      smartmock_next User
    end
  
    it "should create a user and save the attributes" do
      controller = dispatch_to(Users, :create, {:user => {:login => "test"}})
      User.last_smartmock.login.should == "test" # Verifies that the attributes get assigned
      User.last_smartmock.should_not be_dirty # Verifies that the object was saved
    end
  end
  
Without Smartmock:

  describe Users, "show action" do
    before(:each) do
      @user = mock("User", :to_xml => "XML")
    end
    
    it "should create a user and save the attributes" do
      User.should_receive(:new).with("login" => "test').and_return(@user)
      @user.should_receive!(:save).and_return(true)
      controller = dispatch_to(Users, :create, {:user => {:login => "test"}})
    end
  end


== How to use

  require 'rubygems'
  gem 'mutle-smartmock'
  require 'smartmock'
  
  user = Smartmock[User].new(:login => 'mutle')
  user.name = 'Mutwin Kraus' # Smartmock adds methods for all attributes of the mocked model
  user.dirty? # => true
  user.save # This doesn't write anything to the database
  user.dirty? # => false

== Installation

  gem source --add http://gems.github.com/
  gem install mutle-smartmock

== Authors

Smartmock is written by Mutwin Kraus (<http://gitub.com/mutle>).
