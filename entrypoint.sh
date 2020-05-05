#!/bin/sh
set -e

# Starting virtual X frame buffer
/etc/init.d/xvfb start

cat /version

# running command
if [ $# -gt 0 ]; then
  exec su - katalon -c "$@"
fi
