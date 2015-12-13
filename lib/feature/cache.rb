
module Feature
  # Provide simple value caching through the <tt>cache</tt> private method.
  #
  #   require "feature/cache"
  #
  #   class Person
  #     Feature::Cache.load(self)
  #
  #     attr_reader :first_name
  #     attr_reader :last_name
  #
  #     def full_name
  #       # This value is cached.
  #       cache[:full_name] ||= "#{first_name} #{last_name}"
  #     end
  #
  #     def first_name=(s)
  #       cache.clear
  #       @first_name = s
  #     end
  #
  #     def last_name=(s)
  #       cache.clear
  #       @last_name = s
  #     end
  #   end
  #
  # @see Cache.load
  # @see DefaultMode::InstanceMethods#cache
  module Cache
    # Activate feature.
    #
    #   class Klass
    #     # Default mode.
    #     Feature::Cache.load(self)                       # Default mode.
    #
    #     # Invisible mode. Cache will be hidden from `.inspect`.
    #     Feature::Cache.load(self, invisible: true)      # Invisible mode.
    #
    #     ...
    #   end
    #
    # Options:
    #
    #   :invisible => T|F         # Cache values will not be visible via `inspect`. Default is `false`.
    def self.load(owner, options = {})
      o = {}
      options = options.dup
      o[k = :invisible] = options.include?(k) ? options.delete(k) : false
      raise ArgumentError, "Unknown options: #{options.inspect}" if not options.empty?

      # Activation check.
      return if owner < DefaultMode::InstanceMethods or owner < InvisibleMode::InstanceMethods

      owner.send(:include, o[:invisible] ? InvisibleMode::InstanceMethods : DefaultMode::InstanceMethods)
    end

    module DefaultMode
      module InstanceMethods
        private

        # A <tt>Hash</tt> collection of cached values.
        #
        # Using the cache:
        #
        #   def full_name
        #     cache[:full_name] ||= "#{first_name} #{last_name}"
        #   end
        #
        # Clearing the cache:
        #
        #   def first_name=(s)
        #     cache.clear
        #     @first_name = s
        #   end
        #
        # NOTE: It is <b>not recommended</b> to to clear individual cache keys. If you change anything which affects the cache -- clear it all.
        def cache
          @cache ||= {}
        end
      end
    end # DefaultMode

    module InvisibleMode
      module InstanceMethods
        private

        # @see DefaultMode::InstanceMethods#cache
        def cache
          singleton_class.instance_variable_get(k = :@cache) || singleton_class.instance_variable_set(k, {})
        end
      end
    end # InvisibleMode
  end
end
