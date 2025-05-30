#!/usr/bin/env bash
set -e

mkdir -p /tmp/log
touch /tmp/log/production.log

rm -f /app/tmp/pids/server.pid
exec "$@"
