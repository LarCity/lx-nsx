# frozen_string_literal: true

require 'thor/shell/color'

module LarCity
  module CLI
    module Utils
      class Say < Thor::Shell::Color
        def initialize(verbose: false, mute: false, always_force: false, padding: 0)
          super()
          @mute = mute
          @always_force = always_force
          @padding = padding
          @verbose = verbose
        end

        def debug(message)
          say(message, Colors::VERBOSE) if verbose?
        end

        def info(message)
          say(message, Colors::INFO)
        end

        def warning(message)
          say(message, Colors::WARNING)
        end

        def success(message)
          say(message, Colors::SUCCESS)
        end

        def highlight(message)
          say(message, Colors::HIGHLIGHT)
        end

        def error(message)
          say(message, Colors::ERROR)
        end

        protected

        def print_line_break(span: 50)
          say('=' * span)
        end

        # Shows a calculated number of visible characters (i.e. visible_length)
        # at both the start and end, where visible_length is the maximum
        # of 2 or 1/4 of the secret length.
        def partially_masked_secret(secret)
          return '' if secret.nil? || secret.empty?

          visible_length = [2, (secret.length / 4).ceil].max
          masked_length = secret.length - (visible_length * 2)
          if masked_length.positive?
            "#{secret[0, visible_length]}#{'*' * masked_length}#{secret[-visible_length, visible_length]}"
          else
            secret
          end
        end

        def debug?
          @debug ||= (ENV.fetch('LOG_LEVEL', 'debug').downcase == 'debug')
        end

        alias verbose? debug?

        def production?
          ruby_env == 'production'
        end

        def ruby_env
          ENV.fetch('RUBY_ENV', rails_env)
        end

        def rails_env
          ENV.fetch('RAILS_ENV', 'development')
        end
      end
    end
  end
end
