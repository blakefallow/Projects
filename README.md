# Local Environment - Setup instructions

This environment relies on docker and docker-compose. If using a mac you will also require [homebrew], [docker-osx-dev], and [docker-machine]. [kitematic] is optional, but recomended if you use a mac.
#### Install [Homebrew]
```ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```

#### Install NVM and node:0.12
```
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
source ~/.profile
nvm ls-remote
nvm install 0.12
nvm alias default 0.12
nvm use default
```

#### Install docker-machine v0.5.2
```
curl -L https://github.com/docker/machine/releases/download/v0.5.2/docker-machine_darwin-amd64.zip >machine.zip && \
    unzip machine.zip && \
    rm machine.zip && \
    mv docker-machine* /usr/local/bin
```
#### Create a VM to host docker with docker-machine
```docker-machine create --driver virtualbox --virtualbox-memory "4096" default```

If you receive the msg `host already exists: default`, it indicates you already have a machine with this name. If you are having problems with the existing machine and want to replace it, run `docker-machine rm default`, otherwise if you already have a working docker-machine, you do not need to worry about running the `docker-machine create` cmd.

#### Install docker-osx-dev 
```
curl -o /usr/local/bin/docker-osx-dev https://raw.githubusercontent.com/brikis98/docker-osx-dev/master/src/docker-osx-dev
chmod +x /usr/local/bin/docker-osx-dev
docker-osx-dev install
cd flexbox
docker-osx-dev #This process must run in the background
```

Note: you may receive the following warning message, which you can safely ignore:
```
Warning: Could not create link for homebrew/dupes/gdb, as it
conflicts with Homebrew/homebrew/gdb. You will need to use the
fully-qualified name when referring this formula, e.g.
brew install homebrew/dupes/gdb
```

Note: If you get the following msg, this means you have not set certain env variables that are required for setup. Please add them manually by running `eval "$(docker-machine env <machine-name>)"` or add that statement to your .bashrc/.bash_profile file.
```
error in run: Failed to initialize machine "boot2docker-vm": exit status 1
```

Note: You may / should also receive the following msg. This is for folders mounted on your current machine, you can safely answer yes and continue through the process.
```
Found VirtualBox shared folders on your Boot2Docker VM. These may void any performance benefits from using docker-osx-dev:
<some-folders>
Would you like this script to remove them?
```

The final step which syncs your local drives to the docker-machine takes several minutes.


#### Install Bower and Gulp
npm install bower -g
npm install gulp -g

#### Start Your Engines
```
mkdir ~/workspace
cd ~/workspace
git clone git@github.com:FlexShopper/FlexBox.git
cd Flexbox
./setup.sh or ./setup.ubuntu.sh
```

####  Usefull Commands
```
# Sometimes the vm kitematic creates by has issues with mapping drives and space for building images gets limited to 1.9GB then it fails
# Build a docker-machine manually in virtualbox and set the memory
docker-machine create --driver virtualbox --virtualbox-memory "4096" default

# Load data onto mongo docker container ( NOTE: IP and Port may differ )
cd mongo && mongorestore -d FlexMarket ./FlexMarket --host=192.168.99.100 --port=XXXX 

#Set environment variables to connect docker client to the docker api on your VM
eval "$(docker-machine env default)"

# Stop commit and push mongo container image to dockerhub to save data
MONGO_CONTAINER_ID=`docker ps |grep mongo | awk '{print $1;}'`
docker stop $MONGO_CONTAINER_ID && docker commit -m "new data" $MONGO_CONTAINER_ID flexhub/flexbox_mongo:latest
docker login 
docker push flexhub/flexbox_mongo:latest

# Stop commit and push elasticsearch container image to dockerhub to save data
ELS_CONTAINER_ID=`docker ps |grep elasticsearch | awk '{print $1;}'`
docker stop $ELS_CONTAINER_ID && docker commit -m "new data" $ELS_CONTAINER_ID flexhub/flexbox_elasticsearch:latest
docker login 
docker push flexhub/flexbox_elasticsearch:latest
```





[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does it's job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [kitematic]: <https://kitematic.com>
   [Homebrew]: <https://brew.sh>
   [docker-osx-dev]: <https://github.com/brikis98/docker-osx-dev>
   [docker-machine]: <https://docs.docker.com/machine/install-machine/>

