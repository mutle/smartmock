module Smartmock
  
  module Next
    module ClassMethods
      def smartmock_new(attribs={})
        @last_mock = Mock.new(self, attribs)
        if @smartmock_stubs
          @last_mock.stubs = @smartmock_stubs
        end
        revert_smartmock_next
        @last_mock
      end
      
      def last_smartmock
        @last_mock
      end
      
      def smartmock_next_stub(stubs)
        @smartmock_stubs = stubs
      end
      
      
      def revert_smartmock_next
        class << self
          alias new orig_new
        end
      end
      
      def setup_smartmock_next
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
  
  module Find
    module ClassMethods
      def smartmock_find_id(id, *args)
        revert_smartmock_find
        (@smartmocks and @smartmocks[id]) ? @smartmocks[id] : nil
      end
      
      def smartmock_find_id!(id, *args)
        revert_smartmock_find
        return @smartmocks[id] if @smartmocks and @smartmocks[id]
        raise DataMapper::ObjectNotFoundError
      end
      
      def insert_smartmock(id, mock)
        @smartmocks ||= {}
        @smartmocks[id] = mock
      end
      
      def revert_smartmock_find
        klass = @msmartmock_klass
        if Smartmock.active_record?(klass)
          class << klass
          end
        elsif Smartmock.data_mapper?(klass)
          class << klass
            alias get orig_find_id
            alias get! orig_find_id!
          end
        end
      end
      
      def setup_smartmock_find(klass)
        @msmartmock_klass = klass
        if Smartmock.active_record?(klass)
          class << klass
          end
        elsif Smartmock.data_mapper?(klass)
          class << klass
            alias orig_find_id get
            alias orig_find_id! get!
            alias get smartmock_find_id
            alias get! smartmock_find_id!
          end
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
  
end


class Object
  def smartmock_next(klass, stubs={})
    klass.send :include, Smartmock::Next
    klass.setup_smartmock_next
    klass.smartmock_next_stub(stubs)
  end
  
  def smartmock_insert(mock, conditions={})
    klass = mock.klass
    klass.send :include, Smartmock::Find
    klass.setup_smartmock_find(mock.klass)
    klass.insert_smartmock(mock.id, mock)
  end
end