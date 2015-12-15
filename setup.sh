#!/usr/bin/env bash

git clone git@github.com:FlexShopper/FlexMarketWeb.git
git clone git@github.com:FlexShopper/FlexMarket.git


cd FlexMarketWeb && git checkout docker_compose
npm install
gulp

cd ../FlexMarket && git checkout docker_compose
npm install 
cd client npm install && bower install 
eval "$(docker-machine env default)"

cd ../.. && docker-compose build

