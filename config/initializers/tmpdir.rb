# frozen_string_literal: true

require "tmpdir"

# config/initializers/tmpdir.rb

require "tmpdir"

class << Dir
  def tmpdir
    env_tmp = ENV["TMPDIR"]
    if env_tmp && File.directory?(env_tmp) && File.writable?(env_tmp)
      return env_tmp
    end

    # Intentionally skip checking `.` (Dir.pwd) because in containerized environments,
    # the working directory (e.g., /app) may be read-only, which will cause Ruby to raise
    # an ArgumentError during temp file creation even if TMPDIR is correctly set.
    ["/app/tmp", "/tmp", "/var/tmp"].each do |path|
      return path if File.directory?(path) && File.writable?(path)
    end

    raise ArgumentError, "could not find a writable temporary directory"
  end
end
