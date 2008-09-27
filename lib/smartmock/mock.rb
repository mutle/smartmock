module Smartmock
  
  def self.mock(klass)
    MockProxy.new(klass)
  end
  
  def self.[](klass)
    mock(klass)
  end
  
  class MockProxy
    def initialize(klass)
      @klass = klass
    end
    
    def new(attribs={})
      Mock.new(@klass, attribs)
    end
    
    def create(attribs={})
      mock = Mock.new(@klass, attribs)
      mock.save
      mock
    end
  end
  
  module Next
    module ClassMethods
      def smartmock_new(attribs={})
        @last_mock = Mock.new(self, attribs)
        if @smartmock_stubs
          @last_mock.stubs = @smartmock_stubs
        end
        revert_smartmock
        @last_mock
      end
      
      def last_smartmock
        @last_mock
      end
      
      def smartmock_stub(stubs)
        @smartmock_stubs = stubs
      end
      
      
      def revert_smartmock
        class << self
          alias new orig_new
        end
      end
      
      def setup_smartmock
        class << self
          alias orig_new new
          alias new smartmock_new
        end
      end
    end

    module InstanceMethods
      
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
  
  class Mock
    def initialize(klass, attribs={})
      @attributes = {}
      @stubs = {}
      @dirty = false
      @columns = if defined?(ActiveRecord) and klass.superclass == ActiveRecord::Base
        klass.columns.map { |col| col.name.to_s }
      elsif defined?(DataMapper) and klass.respond_to?(:properties)
        klass.properties.map { |prop| prop.name.to_s }
      else
        []
      end
      attribs.each do |key, val|
        self.send("#{key}=".to_sym, val)
      end
    end
    
    def stubs=(stubs)
      @stubs = stubs
    end
    
    def method_missing(meth, *args)
      @columns.each do |col|
        if meth.to_s == col
          return @attributes[col]
        elsif meth.to_s == "#{col}="
          @dirty = true
          @attributes[col] = args.first
          return
        end
      end
      @stubs.each do |stub,value|
        if stub.to_s == meth.to_s
          return value
        end
      end
      raise NameError, "Method #{meth.to_s} is not defined"
    end
    
    def dirty?
      @dirty
    end
    
    def save
      @dirty = false
    end
    alias_method :save!, :save
  end
end


class Object
  def smartmock_next(klass, stubs={})
    klass.send :include, Smartmock::Next
    klass.setup_smartmock
    klass.smartmock_stub(stubs)
  end
end