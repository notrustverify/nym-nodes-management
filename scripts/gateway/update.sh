#! /bin/bash

set -e

WORKDIR=${WORKDIR:-/data/nym}
SERVICE_NAME_GATEWAY=${SERVICE_NAME_GATEWAY:-nym-gateway}
GATEWAYS_DIR=~/.nym/gateways/${NAME_GATEWAY}
FORCE_INIT=${FORCE_INIT:-false}

mkdir -p $WORKDIR
cd $WORKDIR

# Get the latest binaries release
if [[ ! -v VERSION_DOWNLOAD || ! -z VERSION_DOWNLOAD ]]; then
   LATEST_RELEASE=$(curl -s 'https://api.github.com/repos/nymtech/nym/releases' | sed -n '0,/.*"tag_name": "\(nym-binaries.*\)",/s//\1/p')
else
   LATEST_RELEASE=nym-binaries-v${VERSION_DOWNLOAD}
fi

wget -q https://github.com/nymtech/nym/releases/download/${LATEST_RELEASE}/nym-gateway -O nym-gateway-${LATEST_RELEASE} && chmod u+x nym-gateway-${LATEST_RELEASE}
if [[ $? -ne 0 ]]; then
	echo "Error with version ${VERSION_DOWNLOAD}. It doesn't exist"
	exit 1
fi


#Get nym GATEWAY release
EXEC_VERSION=$(./nym-gateway-${LATEST_RELEASE} -V | sed 's:nym-gateway::' |xargs)

# Get running GATEWAY version
if [ -f "${GATEWAYS_DIR}/config/config.toml" ]; then
	CONFIG_VERSION=$(cat "${GATEWAYS_DIR}/config/config.toml" | awk -F "=" '/version/ {print $2}' | xargs)
fi

if [[ $EXEC_VERSION != $CONFIG_VERSION || $FORCE_INIT == true ]];then 
   
   echo "Stop the service"
   service ${SERVICE_NAME_GATEWAY} stop
   mv nym-gateway-${LATEST_RELEASE} nym-gateway

   echo "Init nym client"
   if [[ -v ANNOUNCE_HOST ]]; then
      	./nym-gateway init --id $NAME_GATEWAY --host 0.0.0.0 
       else
        ./nym-gateway init --id $NAME_GATEWAY --host 0.0.0.0
   fi

   echo "Start the service"
   service ${SERVICE_NAME_GATEWAY} start
   
   echo "Updated"
else
   rm -fr nym-gateway-${LATEST_RELEASE}
fi

