module Smartmock
  
  def self.mock(klass)
    MockProxy.new(klass)
  end
  
  def self.[](klass)
    mock(klass)
  end
  
  def self.active_record?(klass)
    defined?(ActiveRecord) and klass.superclass == ActiveRecord::Base
  end
  
  def self.data_mapper?(klass)
    defined?(DataMapper) and klass.respond_to?(:properties)
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
  
  class Mock
    attr_accessor :klass
    
    def initialize(klass, attribs={})
      @attributes = {}
      @stubs = {}
      @dirty = false
      @columns = if Smartmock.active_record?(klass)
        klass.columns.map { |col| col.name.to_s }
      elsif Smartmock.data_mapper?(klass)
        klass.properties.map { |prop| prop.name.to_s }
      else
        []
      end
      @columns << "id"
      attribs.each do |key, val|
        @columns << key.to_s unless @columns.include?(key.to_s)
        self.send("#{key}=".to_sym, val)
      end
      @klass = klass
    end
    
    def id
      @attributes["id"]
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
