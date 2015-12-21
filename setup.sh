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

curl -o /usr/local/bin/docker-osx-dev https://raw.githubusercontent.com/brikis98/docker-osx-dev/master/src/docker-osx-dev
chmod +x /usr/local/bin/docker-osx-dev

cd ../flexbox
docker-machine rm default
docker-machine create --driver virtualbox --virtualbox-memory "4096" default
eval "$(docker-machine env default)"
docker-osx-dev install
docker-osx-dev #This process must run in the background
echo "\n\nBUILDING ENVIRONMNET\n\n"
#How do I not run the next 2 lines if on Ubuntu

cd  && docker-compose build && docker-compose up -d && docker-compose ps

