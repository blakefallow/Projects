#!/usr/bin/env bash

git clone git@github.com:FlexShopper/FlexMarketWeb.git
git clone git@github.com:FlexShopper/FlexMarket.git


cd FlexMarketWeb && git checkout docker_compose
npm install
gulp

cd ../FlexMarket && git checkout docker_compose
npm install 

cd client 
npm install 
bower install 
gulp

echo "\n\nBUILDING ENVIRONMNET\n\n"
#How do I not run the next 2 lines if on Ubuntu
docker-machine start default
eval "$(docker-machine env default)"

cd ../.. && docker-compose build && docker-compose up -d && docker-compose ps

