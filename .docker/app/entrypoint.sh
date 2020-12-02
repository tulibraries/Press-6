#!/usr/bin/env bash
set -e

bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup
rails sync:pressworks:all[press.xml]
rm -f /app/.internal_test_app/tmp/pids/server.pid
exec "$@"
