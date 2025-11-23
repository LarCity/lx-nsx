# frozen_string_literal: true

require 'thor'
require 'awesome_print'
require 'lar_city/cli/utils/operating_system_detectable'
require 'lar_city/cli/utils'
require 'lar_city/cli/interruptible'
require 'lar_city/cli/runnable'
require 'lx/nsx/utils'

module LarCity
  module CLI
    class CoreCmd < Thor
      def self.exit_on_failure?
        true
      end

      no_commands do
        include Utils::OperatingSystemDetectable
        include EnvHelpers
        include OutputHelpers
      end

      EnvHelpers.define_class_options(self)
      OutputHelpers.define_class_options(self)

      no_commands do
        protected

        def things(count, name: 'item')
          name.pluralize(count)
        end

        def tally(collection, name)
          return unless is_enumerable?(collection)

          count = collection.count
          "#{count} #{things(count, name:)}"
        end

        def range(collection)
          return unless is_enumerable?(collection)
          return unless collection.any?

          count = collection.count
          return '[1]' if count == 1

          "[1-#{count}]"
        end

        def is_enumerable?(collection)
          collection.class.ancestors.include?(Enumerable)
        end
      end
    end
  end
end
