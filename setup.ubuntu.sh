#!/usr/bin/env bash
#increase file watching max on ubuntu
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

rm -f /tmp/flexmarket_api_gulp.out

git clone git@github.com:FlexShopper/FlexMarketWeb.git
git clone git@github.com:FlexShopper/FlexMarket.git

cd FlexMarketWeb && git checkout development
npm install
gulp

cd ../FlexMarket && git checkout development
npm install

cd client
npm install
bower install

gulp > /tmp/flexmarket_api_gulp.out &

cd ../..
docker-compose up
