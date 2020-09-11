namespace :jobs do
  desc "Refresh materialized view"
  task :refresh_materialized_view => :environment do
    RefreshMaterializedViewWorker.perform_async
  end
end
