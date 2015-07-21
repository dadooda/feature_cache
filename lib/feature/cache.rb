
module Feature
  # Provide simple value caching through the <tt>cache</tt> private method.
  #
  # @see DefaultMode::InstanceMethods#cache
  module Cache
    # Activate feature.
    #
    #   class Klass
    #     Feature::Cache.load(self)                       # Default mode.
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

        # On-demand cache container.
        #
        # Using the cache:
        #
        #   def full_name
        #     cache[:full_name] ||= "#{first_name} #{last_name}"
        #   end
        #
        # Clearing the cache:
        #
        #   def first_name=(value)
        #     cache.clear
        #     @first_name = value
        #   end
        #
        # NOTE: It is <b>not recommended</to to clear individual keys with <tt>cache.delete</tt>.
        #       If you change anything related to the cache -- clear it all.
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
