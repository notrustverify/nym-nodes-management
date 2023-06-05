#! /bin/bash

set -e

WORKDIR=${WORKDIR:-/data/nym}
SERVICE_NAME_MIXNODE=${SERVICE_NAME_GATEWAY:-nym-mixnode}
MIXNODES_DIR=~/.nym/mixnodes/${NAME_MIXNODE}
FORCE_INIT=${FORCE_INIT:-false}

mkdir -p $WORKDIR
cd $WORKDIR

# Get the latest binaries release
if [[ ! -v VERSION_DOWNLOAD || ! -z VERSION_DOWNLOAD ]]; then
   LATEST_RELEASE=$(curl -s 'https://api.github.com/repos/nymtech/nym/releases' | sed -n '0,/.*"tag_name": "\(nym-binaries.*\)",/s//\1/p')
else
   LATEST_RELEASE=nym-binaries-v${VERSION_DOWNLOAD}
fi

wget -q https://github.com/nymtech/nym/releases/download/${LATEST_RELEASE}/nym-mixnode -O nym-mixnode-${LATEST_RELEASE} && chmod u+x nym-mixnode-${LATEST_RELEASE}
if [[ $? -ne 0 ]]; then
        echo "Error with version ${VERSION_DOWNLOAD}. It doesn't exist"
        exit 1
fi

#Get nym mixnode release
EXEC_VERSION=$(./nym-mixnode-${LATEST_RELEASE} -V | sed 's:nym-mixnode::' |xargs)

# Get running mixnode version
if [ -f "${MIXNODES_DIR}/config/config.toml" ]; then
	CONFIG_VERSION=$(cat "${MIXNODES_DIR}/config/config.toml" | awk -F "=" '/version/ {print $2}' | xargs)
fi

if [[ $EXEC_VERSION != $CONFIG_VERSION || $FORCE_INIT == true ]];then 
   
   echo "Stop the service"
   service nym-mixnode stop
   mv nym-mixnode-${LATEST_RELEASE} nym-mixnode

   echo "Init nym client"
   if [[ -v ANNOUNCE_HOST ]]; then
      	./nym-mixnode init --id $NAME_MIXNODE  --announce-host $ANNOUNCE_HOST --host 0.0.0.0 --wallet-address $WALLET_ADDRESS
       else
        ./nym-mixnode init --id $NAME_MIXNODE --announce-host $(curl ifconfig.me)  --host 0.0.0.0 --wallet-address $WALLET_ADDRESS
   fi

   echo "Start the service"
   service nym-mixnode start
   
   echo "Updated"
else
   rm -fr nym-mixnode-${LATEST_RELEASE}
fi

