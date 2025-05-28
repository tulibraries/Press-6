# frozen_string_literal: true

require "tmpdir"

module Dir
  class << self
    def tmpdir
      env_tmp = ENV["TMPDIR"]
      if env_tmp && File.directory?(env_tmp) && File.writable?(env_tmp)
        return env_tmp
      end
      # Skip checking `.` which is `/app` and not writable
      ["/app/tmp", "/tmp", "/var/tmp"].each do |path|
        return path if File.directory?(path) && File.writable?(path)
      end
      raise ArgumentError, "could not find a writable temporary directory"
    end
  end
end
