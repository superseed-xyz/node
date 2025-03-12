#!/bin/sh
set -e
#initialisation required if starting node from scratch
# exec geth init --datadir="/op-data/" --state.scheme="hash" /config/${NETWORK_NAME}/genesis.json
exec geth \
    --datadir=/op-data/ \
    --ws \
    --ws.api=eth,net,web3,debug,txpool \
    --ws.port=8546 \
    --ws.addr=0.0.0.0 \
    --ws.origins=* \
    --http \
    --http.api=eth,net,web3,debug,txpool \
    --http.port=8545 \
    --http.addr=0.0.0.0 \
    --http.vhosts=* \
    --http.corsdomain=* \
    --authrpc.addr=0.0.0.0 \
    --authrpc.jwtsecret=/op-data/secret.jwt \
    --authrpc.vhosts=* \
    --authrpc.port=8551 \
    --verbosity=3 \
    --rollup.disabletxpoolgossip=false \
    --rpc.allow-unprotected-txs=true \
    --syncmode=full \
    --maxpeers=100 \
    --metrics \
    --metrics.addr=0.0.0.0 \
    --metrics.port=6060 \
    --state.scheme=hash \
    --gcmode=archive \
    --rollup.sequencerhttp=https://sepolia.superseed.xyz \
    --rollup.halt=major \
    --override.granite=1732546800 \
    --override.holocene=1732633200                                        
