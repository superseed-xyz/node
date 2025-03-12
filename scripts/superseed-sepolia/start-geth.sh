#!/bin/sh
set -e
# Start geth.
exec geth \
  --sepolia \
  --datadir="/data/geth/" \
  --http --http.port=8545 --http.addr=0.0.0.0 --http.vhosts=* --http.corsdomain=* \
  --ws --ws.port=8546 --ws.addr=0.0.0.0 --ws.origins=* \
  --authrpc.addr=0.0.0.0 \
  --authrpc.jwtsecret=/data/secret.jwt \
  --authrpc.vhosts=* \
  --authrpc.port=8551 \
  --syncmode=full \
  --maxpeers=100 \
  --http.api=eth,net,web3,debug,txpool,engine,admin \
  --ws.api=eth,net,web3,debug,txpool \
  --metrics \
  --metrics.addr=0.0.0.0 \
  --metrics.port=6060
