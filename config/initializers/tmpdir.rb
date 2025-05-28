# config/initializers/tmpdir.rb
ENV['TMPDIR'] = '/app/tmp'

require 'tmpdir'

# Monkey-patch Dir.tmpdir only if needed
if Dir.respond_to?(:tmpdir)
  module Dir
    class << self
      def tmpdir
        ENV['TMPDIR'] || '/app/tmp'
      end
    end
  end
end
