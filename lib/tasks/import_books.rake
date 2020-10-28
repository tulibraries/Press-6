# frozen_string_literal: true

namespace :sync do
  desc "sync books"
  task :books, [:path] => :environment do |t, args|
    args.with_defaults(path: nil)
    SyncService::Books.call(xml_path: args[:path])
  end
end