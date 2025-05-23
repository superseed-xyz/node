#!/bin/sh
set -e

# Start op-node.
exec op-node \
    --l1=https://your-eth-${NETWORK_NAME}-rpc-endpoint \
    --l2=ws://op-geth:8551 \
    --rpc.addr=0.0.0.0 \
    --rpc.port=9545 \
    --l2.jwt-secret=/op-data/secret.jwt \
    --metrics.enabled \
    --rollup.load-protocol-versions=true \
    --rollup.config /config/${NETWORK_NAME}/rollup.json \
    --override.holocene=1736445601 \
    --override.granite=1726185601 \
    --override.isthmus=1746806401 \
    --l1.beacon=https://your-beacon-node-endpoint \
    --p2p.bootnodes=enode://your-bootnodes \
    --p2p.static=/ip4/static-ip \
    --p2p.sync.onlyreqtostatic=true
