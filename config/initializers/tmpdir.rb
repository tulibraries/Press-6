# Only run this initializer in runtime contexts
unless ENV['SKIP_TMPDIR_INIT']
  require 'tmpdir'

  if ENV['TMPDIR'].nil? || !File.writable?(ENV['TMPDIR'])
    raise "TMPDIR is not set or is not writable: #{ENV['TMPDIR'].inspect}"
  end

  puts "Using TMPDIR: #{ENV['TMPDIR']}"
end

