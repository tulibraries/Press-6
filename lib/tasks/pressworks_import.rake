# frozen_string_literal: true

namespace :sync do
  namespace :pressworks do
    desc "sync books"
    task :books, [:path] => :environment do |t, args|
      args.with_defaults(path: nil)
      SyncService::Books.call(xml_path: args[:path])
    end
    desc "sync catalogs"
    task :catalogs, [:path] => :environment do |t, args|
      args.with_defaults(path: nil)
      SyncService::Catalogs.call(xml_path: args[:path])
    end
    desc "sync series"
    task :series, [:path] => :environment do |t, args|
      args.with_defaults(path: nil)
      SyncService::Series.call(xml_path: args[:path])
    end
    desc "sync reviews"
    task :reviews, [:path] => :environment do |t, args|
      args.with_defaults(path: nil)
      SyncService::Reviews.call(xml_path: args[:path])
    end
    desc "sync subjects"
    task :subjects, [:path] => :environment do |t, args|
      args.with_defaults(path: nil)
      SyncService::Subjects.call(xml_path: args[:path])
    end
  end
end