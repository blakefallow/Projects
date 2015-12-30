#!/usr/bin/env bash
rm -f /tmp/flexmarket_api_gulp.out /tmp/docker-osx-dev.out

curl -o /usr/local/bin/docker-osx-dev https://raw.githubusercontent.com/brikis98/docker-osx-dev/master/src/docker-osx-dev
chmod +x /usr/local/bin/docker-osx-dev

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
docker-machine rm default &&
docker-machine create --driver virtualbox --virtualbox-memory "4096" default &&
printf "\n\n\n\nCreating symlink to machines\n\n\n\n"
ln -s ~/.docker/machine/machines/ machines
printf "\n\n\n\nLoading env vars\n\n\n\n"
eval "$(docker-machine env default)"
printf "\n!\n!\n!\nPlease answer 'yes' to the next prompt.\n!\n!\n!\n"
docker-osx-dev install
printf "\n\n\n\nRunning docker-osx-dev in the background.\n" 
printf "When the repos are finished syncing to the VM the script will continue to watch your file system and sync changes to the VM\n\n\n\n"
docker-osx-dev > /tmp/docker-osx-dev.out &
tail -f /tmp/docker-osx-dev.out | while read LOGLINE
do
   [[ "${LOGLINE}" == *"Watching"* ]] && pkill -P $$ tail
done
printf "\n\n\n\nRunning docker-compose up\n\n\n\n"
docker-compose up
