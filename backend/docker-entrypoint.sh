#!/bin/sh
set -e

echo "Running Prisma migrations with retry mechanism..."

RETRIES=10
until npx prisma migrate deploy; do
  echo "Prisma migration failed. Retrying in 3 seconds... ($RETRIES retries left)"
  RETRIES=$((RETRIES - 1))
  if [ "$RETRIES" -eq 0 ]; then
    echo "Failed to run Prisma migrations after multiple attempts."
    exit 1
  fi
  sleep 3
done

echo "Starting BugTraceAI-WEB Backend..."
exec node dist/index.js
