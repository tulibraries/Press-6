# frozen_string_literal: true

# Only run this initializer in runtime contexts

unless ENV["SKIP_TMPDIR_INIT"]
  require "tmpdir"

  if ENV["TMPDIR"].nil? || !File.writable?(ENV["TMPDIR"])
    raise "TMPDIR is not set or is not writable: #{ENV['TMPDIR'].inspect}"
  end

  Rails.logger.info "Using TMPDIR: #{ENV['TMPDIR']}" if defined?(Rails)
end
