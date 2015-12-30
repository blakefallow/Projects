#!/usr/bin/env bash
git clone git@github.com:FlexShopper/FlexMarketWeb.git
git clone git@github.com:FlexShopper/FlexMarket.git


cd FlexMarketWeb && git checkout development
npm install
gulp

cd ../FlexMarket && git checkout docker_compose
npm install 

cd client 
npm install 
bower install 

gulp > /tmp/flexmarket_api_gulp.out &

cd ../..
