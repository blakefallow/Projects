#!/usr/bin/env bash
rm -f /tmp/flexmarket_api_gulp.out /tmp/docker-osx-dev.out

curl -o /usr/local/bin/docker-osx-dev https://raw.githubusercontent.com/brikis98/docker-osx-dev/master/src/docker-osx-dev
chmod +x /usr/local/bin/docker-osx-dev
