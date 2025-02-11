ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address =>              'smtp.gmail.com',
  :port =>                 '587',
  :domain =>               'gmail.com',
  :user_name =>            ENV['PYKIH_DEV_EMAIL'],
  :password =>             ENV['PYKIH_DEV_PASSWORD'],
  :authentication =>       :plain,
  :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options = { host: ENV['HOST_ADDRESS'], port: ENV['HOST_PORT'] }
ActionMailer::Base.perform_deliveries = true
