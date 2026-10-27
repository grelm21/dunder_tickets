#!/bin/sh

set -e

if [ -f tmp/pids/server_1.pid ]; then
  rm tmp/pids/server_1.pid
fi

if [ -f tmp/pids/server_2.pid ]; then
  rm tmp/pids/server_2.pid
fi

# Если в compose передан command — выполняем его (bot, console, sidekiq…).
# Иначе — дефолтный web: cron + rails s.
if [ "$#" -gt 0 ]; then
  exec "$@"
fi

# bundle exec whenever --update-crontab
# cron
bundle exec rails s -b 0.0.0.0 -e development
