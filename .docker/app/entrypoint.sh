#!/usr/bin/env bash
set -e

rails db:migrate 2>/dev/null || rails db:setup

if [ "$DB_SYNC" != "no" ]; then
  rails sync:pressworks:all[press.xml]
fi

rm -f /app/tmp/pids/server.pid
exec "$@"
