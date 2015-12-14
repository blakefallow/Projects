# Local Environment - Setup instructions

The new local environment relies on kitematic, docker-machine and docker-compose. Install [kitematic].

#### Start Your Engines

```
git clone git@github.com:FlexShopper/FlexBox.git
cd Flexbox
# Make sure the FlexMarket and FlexBox repos are on the dockercompose branch until they are merged into master
# update FlexMarket/Dockerfile and FlexMarketWeb/Dockerfile with your own path
docker-compose up
# Look up mongo host and port in kitematic and replace below
mongorestore -d FlexMarket ./Mongo/FlexMarket --host=192.168.99.100 --port=32824
```

####  Usefull Commands

```
eval "$(docker-machine env default)"
```
[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does it's job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [kitematic]: <https://kitematic.com>

