web: rails db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -t 25
worker: bundle exec sidekiq -q default -q mailers