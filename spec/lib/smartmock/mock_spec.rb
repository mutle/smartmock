# require File.join(File.dirname(__FILE__), '../../spec_helper.rb')
# 
# describe Smartmock::Mock do
#   
#   context "ActiveRecord" do
#     
#     before :each do
#       setup_ar
#     end
#     
#     it "should mock a AR object" do      
#       obj = ARObject.create(:test => 'test')
#       obj.test.should == 'test'
#       
#       obj2 = Smartmock[ARObject].new(:test => 'test2')
#       obj2.test.should == 'test2'
#       lambda { obj2.test2 }.should raise_error(NameError)
#     end
#     
#     it "should be dirty if not saved" do
#       obj2 = Smartmock[ARObject].new(:test => 'test2')
#       obj2.test.should == 'test2'
#       obj2.should be_dirty
#       obj2.save
#       obj2.should_not be_dirty
#     end
#     
#   end
#   
#   
#   context "DataMapper" do
#     
#     before :all do
#       setup_dm
#     end
#     
#     it "should mock a DM object" do
#       obj = DMObject.create(:test => 'test')
#       obj.test.should == 'test'
#       
#       obj2 = Smartmock[DMObject].new(:test => 'test2')
#       obj2.test.should == 'test2'
#       lambda { obj2.test2 }.should raise_error(NameError)
#     end
#     
#   end
#   
# end
