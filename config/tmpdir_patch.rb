# frozen_string_literal: true

# config/tmpdir_patch.rb

# Patch Dir.tmpdir before any gems load
class << Dir
  def tmpdir
    env_tmp = ENV["TMPDIR"]
    if env_tmp && File.directory?(env_tmp) && File.writable?(env_tmp)
      return env_tmp
    end

    # Intentionally skip checking '.' (Dir.pwd) to avoid errors in read-only workdir environments
    [ENV["TMPDIR"], "/mnt/tmp", "/var/tmp"].each do |path|
      return path if File.directory?(path) && File.writable?(path)
    end

    raise ArgumentError, "could not find a writable temporary directory"
  end
end
