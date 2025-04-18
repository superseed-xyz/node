![Superseed](logo.png)

# Superseed node

Superseed is an Ethereum Layer 2 that rewards those who DeFi. It's built on Optimism's open-source [OP Stack](https://stack.optimism.io/).

> Forked and customized from https://github.com/smartcontracts/simple-optimism-node

A simple docker compose script for launching full / archive node for the Superseed chain.

## Recommended Hardware

### Mainnet

- 8GB+ RAM
- 500 GB SSD (NVME Recommended)
- 100mb/s+ Download

### Testnet

- 8GB+ RAM
- 500 GB SSD (NVME Recommended)
- 100mb/s+ Download

> Note: Please keep in mind if you are going to run also Ethereum node locally (EL+CL layers), these system requirements will significantly grow!

## Installation and Configuration

### Install docker and docker compose

> Note: If you're not logged in as root, you'll need to log out and log in again after installation to complete the docker installation. This command installs docker and docker compose for Ubuntu. For windows and mac desktop or laptop, please use Docker Desktop. For other OS, please find instructions in Google.


```sh
# Update and upgrade packages
sudo apt-get update
sudo apt-get upgrade -y

### Docker and docker compose prerequisites
sudo apt-get install -y curl
sudo apt-get install -y gnupg
sudo apt-get install -y ca-certificates
sudo apt-get install -y lsb-release

### Download the docker gpg file to Ubuntu
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

### Add Docker and docker compose support to the Ubuntu's packages list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

### Install docker and docker compose on Ubuntu
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -aG docker $(whoami)

### Verify the Docker and docker compose install on Ubuntu
sudo docker run hello-world
```

(For non-root user) After logged out and logged back in, test if docker is working by running.

```sh
docker ps
```

It should returns an empty container list without having any error. Otherwise, restart your machine if there are errors.

### Clone the Repository

```sh
git clone https://github.com/superseed-xyz/node
cd node
```

### Copy .env.example to .env

Make a copy of `.env.example` named `.env`.

```sh
cp .env.example .env
```

Open `.env` with your editor of choice

### Mandatory configurations

- **NETWORK_NAME** - Choose which Optimism network layer you want to operate on:
  - `superseed-sepolia` - Superseed Sepolia (Testnet)
  - `superseed-mainnet` - Superseed (Mainnet)
- **NODE_TYPE** - Choose the type of node you want to run:
  - `full` (Full node) - A Full node contains a few recent blocks without historical states.
  - `archive` (Archive node) - An Archive node stores the complete history of the blockchain, including historical states.
- **OP_NODE\_\_RPC_ENDPOINT** - Specify the endpoint for the RPC of Layer 1 (e.g., Ethereum mainnet). For instance, you can use the free plan of Quicknode for the Ethereum mainnet.
- **OP_NODE\_\_L1_BEACON** - Specify the beacon endpoint of Layer 1. You can use [QuickNode for the beacon endpoint](https://www.quicknode.com). For example: https://xxx-xxx-xxx.quiknode.pro/db55a3908ba7e4e5756319ffd71ec270b09a7dce
- **OP_NODE\_\_RPC_TYPE** - Specify the service provider for the RPC endpoint you've chosen in the previous step. The available options are:
  - `alchemy` - Alchemy
  - `quicknode` - Quicknode (ETH only)
  - `erigon` - Erigon
  - `basic` - Other providers


### Snapshots
  
For faster synchronization you can make use of the  following snapshots:


**Mainnet**: https://storage.googleapis.com/conduit-networks-snapshots/superseed-mainnet-0/latest.tar

**Testnet**: https://storage.googleapis.com/conduit-networks-snapshots/sepolia-superseed-826s35710w/latest.tar



### Optional configurations

- **OP_GETH\_\_SYNCMODE** - Specify sync mode for the execution client
  - Unspecified - Use default snap sync for full node and full sync for archive node
  - `snap` - Snap Sync (Default)
  - `full` - Full Sync (For archive node, not recommended for full node)
- **IMAGE_TAG\_\_[...]** - Use custom docker image for specified components.
- **PORT\_\_[...]** - Use custom port for specified components.

## Operating the Node

### Start

```sh
docker compose up -d --build
```

Will start the node in a detached shell (`-d`), meaning the node will continue to run in the background. We recommended to add `--build` to make sure that latest changes are being applied.

> Note: If you want to start the node from scratch, you will need to first initialise the op-geth database, as described in the `start-op-geth.sh` file. This can be skipped if you use a snapshot.

```sh
exec geth init --datadir="/op-data/" --state.scheme="hash" /config/${NETWORK_NAME}/genesis.json
```

### View logs

```sh
docker compose logs -f --tail 10
```

To view logs of all containers.

```sh
docker compose logs <CONTAINER_NAME> -f --tail 10
```

To view logs for a specific container. Most commonly used `<CONTAINER_NAME>` are:

- op-geth
- op-node
- geth
- prysm

### Stop

```sh
docker compose down
```

Will shut down the node without wiping any volumes.
You can safely run this command and then restart the node again.

### Restart

```sh
docker compose restart
```

Will restart the node safely with minimal downtime but without upgrading the node.

### Upgrade

Pull the latest updates from GitHub, and Docker Hub and rebuild the container.

```sh
git pull
docker compose pull
docker compose up -d --build
```

Will upgrade your node with minimal downtime.

### Wipe [DANGER]

```sh
docker compose down -v
```

Will shut down the node and WIPE ALL DATA. Proceed with caution!

## Monitoring Guidelines

In order to maintain a healthy node that passes the Integrity Protocol's checks, you should have a monitoring system in place. Blockchain nodes usually offer metrics regarding the node's behaviour and health - a popular way to offer these metrics is Prometheus-like metrics. The most popular monitoring stack, which is also open source, consists of:

* Prometheus - scrapes and stores metrics as time series data (blockchain nodes cand send the metrics to it);
* Grafana - allows querying, visualization and alerting based on metrics (can use Prometheus as a data source);
* Alertmanager - handles alerting (can use Prometheus metrics as data for creating alerts);
* Node Exporter - exposes hardware and kernel-related metrics (can send the metrics to Prometheus).

We will assume that Prometheus/Grafana/Alertmanager are already installed (we will provide a detailed guide of how to set up monitoring and alerting with the Prometheus + Grafana stack at a later time; for now, if you do not have the stack already installed, please follow this official basic guide [here](https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-prometheus/)).

We recommend installing the Node Exporter utility since it offers valuable information regarding CPU, RAM & storage. This way, you will be able to monitor possible hardware bottlenecks, or to check if your node is underutilized - you could use these valuable insights to make decisions regarding scaling up/down the allocated hardware resources.

In the config folder of the repo you can find a script that installs Node Exporter as a system service.

### Estimate remaining sync time

Run following `curl` to estimate remaining sync time.
This will show the time until sync is completed.

```
echo "Latest synced block: $(curl -s -d '{"id":0,"jsonrpc":"2.0","method":"optimism_syncStatus"}' -H "Content-Type: application/json" http://localhost:9545 | jq -r '.result.unsafe_l2.number') , behind by: $(( ( $(date +%s) - $(curl -s -d '{
"id":0,"jsonrpc":"2.0","method":"optimism_syncStatus"}' -H "Content-Type: application/json" http://localhost:9545 | jq -r '.result.unsafe_l2.tim
estamp') ) / 3600 )) hours"
```

### Grafana dashboard

Grafana is exposed at [http://localhost:3000](http://localhost:3000) and comes with one pre-loaded dashboard ("Simple Node Dashboard").
Simple Node Dashboard includes basic node information and will tell you if your node ever falls out of sync with the reference L2 node or if a state root fault is detected.

Use the following login details to access the dashboard:

- Username: `admin`
- Password: `superseed`

Navigate over to `Dashboards > Manage > Simple Node Dashboard` to see the dashboard, see the following gif if you need help:

![metrics dashboard gif](https://user-images.githubusercontent.com/14298799/171476634-0cb84efd-adbf-4732-9c1d-d737915e1fa7.gif)


