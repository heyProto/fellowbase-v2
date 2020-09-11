set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every 1.hour do
  rake "jobs:refresh_materialized_view"
end
