web: bundle exec rails server -p $PORT
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}

redis: redis-server
web: bundle exec sidekiq -q default -q mailers
