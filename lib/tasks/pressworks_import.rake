# frozen_string_literal: true

namespace :sync do
  namespace :pressworks do |pressworks_ingest|
    desc "sync books"
    task :books, [:path] => :environment do |_t, args|
      args.with_defaults(path: nil)
      SyncService::Books.call(xml_path: args[:path])
    end
    desc "sync catalogs"
    task :catalogs, [:path] => :environment do |_t, args|
      args.with_defaults(path: nil)
      SyncService::Catalogs.call(xml_path: args[:path])
    end
    desc "sync series"
    task :book_series, [:path] => :environment do |_t, args|
      args.with_defaults(path: nil)
      SyncService::BookSeries.call(xml_path: args[:path])
    end
    desc "sync reviews"
    task :reviews, [:path] => :environment do |_t, args|
      args.with_defaults(path: nil)
      SyncService::Reviews.call(xml_path: args[:path])
    end
    desc "sync subjects"
    task :subjects, [:path] => :environment do |_t, args|
      args.with_defaults(path: nil)
      SyncService::Subjects.call(xml_path: args[:path])
    end
    desc "sync authors"
    task :authors, [:path] => :environment do |_t, args|
      args.with_defaults(path: nil)
      SyncService::Authors.call(xml_path: args[:path])
    end
    desc "Do them all"
    task :all, [:path] => :environment do |_t, args|
      pressworks_ingest.tasks.each do |task|
        Rake::Task[task].invoke(args[:path])
      end
    end
  end
end
