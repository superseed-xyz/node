#!/bin/sh
set -e

# Start op-node.
exec op-node \
    --l1.trustrpc=true \
    --l1=https://your-eth-${NETWORK_NAME}-rpc-endpoint \
    --l1.beacon=https://your-beacon-node-endpoint \
    --l2=ws://op-geth:8551 \
    --rpc.addr=0.0.0.0 \
    --rpc.port=9545 \
    --l2.jwt-secret=/op-data/secret.jwt \
    --metrics.enabled \
    --rollup.load-protocol-versions=true \
    --rollup.config=/config/${NETWORK_NAME}/rollup.json \
    --p2p.bootnodes=enode://your-bootnodes \
    --override.granite=1732546800 \
    --override.holocene=1732633200 \
    --override.pectrablobschedule=1742486400
