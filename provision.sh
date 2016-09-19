#!/bin/bash
echo "setting up swap memory"
shopt -s nocasematch
fallocate -l 4096M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile     none    swap    sw  0   0" | tee -a /etc/fstab
printf "vm.swappiness=10\nvm.vfs_cache_pressure=50\n" | tee -a /etc/sysctl.conf && sysctl -p
shopt -u nocasematch

echo "Installing docker..."
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee -a /etc/apt/sources.list.d/docker.list
apt-get update -qq
apt-get install -y -qq docker-engine 

echo "Installing docker-compose..."
curl -sL https://github.com/docker/compose/releases/download/1.5.2/docker-compose-Linux-x86_64 > docker-compose
sudo mv docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Setting key..."

if [[ ! -d ~/.ssh/ ]]
then
    mkdir ~/.ssh
fi

cat >~/.ssh/git-key << EOF 
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA2HiaUFlYM+VhLK7/Ayt19p3HqHxeyVCDdQnEV1mBsHGpiL90
z8vU39bCpb2/91d0ts7T2J6K3r79VCdGBvvfUnQkD8i6eE4CwbxZQL+QNcPeNv9L
qcNSMdZMgaOBEfhPCxCxR8s5VgWSOmZj+hXXbsxzti7DFJcfPiiAVluJmMAv4Cqt
WkYJ9qwixbSZnS2z+1RPtPXRS1LCTbijnGkjlutkWBuHv+3bVv6aR+tJf+Q5GU53
Fv0i0JCF4M1fkWEhnUEEvpwYDEdPGoFTfcz1TZ5qdEfrFBG6oWH0agCNtiqXtJok
YEuoKq856Q6rNk0eGHyM+7WS6e0O5BRn5iwDwwIDAQABAoIBAQDRuseH4Yhbf3nO
2R2p7Im2DthKnXUYhzFWS8g2+Tl1wioHm7eJPGtbE7Ay9Mzwz4L9OxZ1YeYaOeEn
j4WBbrbIJE5sHIbN2IdDPUEcQn1uGf9KOb8NE3inYIFveQKsbm/mwJ2CeZtrhKpQ
erOSsWawqtXRRS0s3d4fUw5EnRuLKaCrS/rwE+Gl1effZfvJkwKh1i6H/BbfQX7u
zH+FrsYBnoKiutIfcN5Q2QUPmpvDAN4jmk5Mj5Hi/AlR8/LgvdUpW1ID6g9DtUHr
95R1NtH5sWgNuoSNXTZST+qBfXIxVEZsaztJQhMZKHg2cHZFkaLYtwuKU7Ph1SGc
dfdGcKDBAoGBAPVnShzr0G4NXUI6t55XeYBu4Z2IC6DySzBVFICbu2N4H21+CDIH
HRIwBQCOwHm1PW22Djadht0kTeZzMAjD13mwvt5bgBBxzDLyVfghFC8qORFs24ID
Ckk6v8xFJcYsvr985j3gzz/Jpv3A/CKaHyv8eSGNoGkzwpDyQsSu7zTnAoGBAOHR
fhFNVt0vwK2wcZliF5+cu6cvKXnPE+YGJEnkZhl2WR90Y5Awd0H4BA8oWR1nhC5r
9TBqoj2ZXiZ72YFse4mC+Kt4YXWyAhH98VzLVvuthrD9OIlq8jR5mxsj0pq1bAHC
CJF9l/ejZYIOK3JtYRlSIMDuCY8IBcXlmKl0jYLFAoGAQN2zhl+CsYRQ0U/J902x
7RPiCQzL3hgNbdIfYDtJ1eoLjJqSuf6NXaBZwiL5l3IjsZs8uIz89/k/qhlqafay
PxVL7mSLPk2GJzVNKhA8UJc9jHCUuRHqpx6jUfA5It/y75SpG1QQFBFOVaasPs00
TiEnN4pDC2vGEyAmK+z9h6MCgYEAqhPur3lggxcEN808whlvUXfqnfCXfHbKteTK
UB0GCQdp+JbgpijaqYTzCbeJ5uugUpZdBSpLJ7nrf3CoUSIzqU5LnFn+jXaUuJha
wVklGkmHuKX/fwBdi8hLWhWQ+ZTK1Egfy/ScEJewTFP/xR88kqWYpbai3Gdecb6L
TJXMP0ECgYEA5S6ZkBNEnCVxQeYfCbAkl2fxkbSGnIvDbJ6bXGp/bhYfvhTjLp0O
bH079bCzsLIAE40T17xexT3M/6vaUPFQP1lTeyIzTVUiC0vLnTHSNHdNIznpije1
LzEkZxPGJJJ7MopMgCvhgP5tYfxxqoPMZDnouc/yqlecdZjQ6NagFBQ=
-----END RSA PRIVATE KEY-----
EOF

chmod 600 ~/.ssh/git-key
cat >~/.ssh/config << EOF
host github.com
    identityfile ~/.ssh/git-key
EOF

echo "Setting docker config.."
if [[ ! -d /root/.docker ]]
then
    mkdir /root/.docker
fi

if [[ ! -d /home/vagrant/.docker ]]
then
    mkdir /home/vagrant/.docker
fi

cat >/root/.docker/config.json << EOF
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "ZmxleGh1YjpGbGV4MjY1MCE=",
            "email": "josh.stein@flexshopper.com"
        }
    }
}
EOF

cat >/home/vagrant/.docker/config.json << EOF
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "ZmxleGh1YjpGbGV4MjY1MCE=",
            "email": "josh.stein@flexshopper.com"
        }
    }
}
EOF

echo "Installing git..."
apt-get install -qq -y git

echo "Adding github fingerprint..."
ssh-keyscan github.com > ~/.ssh/known_hosts

echo "Installing node..."
apt-get install -qq -y build-essential libssl-dev
git clone https://github.com/creationix/nvm.git /opt/nvm
cd /opt/nvm
git checkout `git describe --abbrev=0 --tags`
cat >>/etc/bash.bashrc << EOF
export NVM_DIR="/opt/nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"  # This loads nvm
EOF
. /opt/nvm/nvm.sh
nvm install 0.12
nvm alias default 0.12
nvm use default
# install latest version of npm, by default comes with 2.x
npm install --silent -g npm

echo "Installing gulp..."
npm install --silent gulp -g

echo "Installing bower.."
npm install --silent bower -g

echo "Pulling FlexBox repository..."
if [[ ! -d ~/workspace ]]
then
    mkdir ~/workspace
fi

cd /vagrant    

if [[ ! -h ~/workspace/FlexBox ]]
then
    ln -s /vagrant ~/workspace/FlexBox
fi

cd ~/workspace/FlexBox
git pull origin master

npm i --silent node-sass -g
su vagrant
echo "Now running FlexBox installation..."
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
rm -f /tmp/flexmarket_api_gulp.out
if [[ ! -d FlexMarketWeb ]]
then
    git clone git@github.com:FlexShopper/FlexMarketWeb.git
fi

if [[ ! -d FlexMarket ]]
then
    git clone  git@github.com:FlexShopper/FlexMarket.git
fi

cd FlexMarketWeb && git checkout development && git pull
npm i --silent
npm i --silent
npm rebuild node-sass
gulp

cd ../FlexMarket && git checkout development && git pull
npm i --silent
npm i --silent

cd ~/workspace/FlexBox
docker-compose up

