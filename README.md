# Local Environment - Setup instructions

The new local environment relies on docker-machine to setup a vm running docker and docker-compose to orchastrate the connection of services in our platform. Install [kitematic] if your on mac. Install docker-machine and set up a default machine if Ubuntu.

#### Start Your Engines
```
git clone git@github.com:FlexShopper/FlexBox.git
cd Flexbox
./setup.sh
# Make sure the FlexMarket and FlexBox repos are on the dockercompose branch until they are merged into master
# update FlexMarket/Dockerfile and FlexMarketWeb/Dockerfile with your own path
docker-compose up
# Look up mongo host and port in kitematic and replace below
mongorestore -d FlexMarket ./Mongo/FlexMarket --host=192.168.99.100 --port=32824
```

### Install NVM and node:0.12


####  Usefull Commands
```
curl -L https://github.com/docker/machine/releases/download/v0.5.2/docker-machine_darwin-amd64.zip >machine.zip && \
    unzip machine.zip && \
    rm machine.zip && \
    mv docker-machine* /usr/local/bin
```

Set environment variables to connect docker client to the docker api on your VM
```
eval "$(docker-machine env default)"
```
[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does it's job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [kitematic]: <https://kitematic.com>

