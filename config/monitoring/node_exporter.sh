# Update packages
sudo apt update -y

# Create a node_exporter user (security best practice)
sudo useradd -rs /bin/false node_exporter

# Download latest Node Exporter release
export VERSION="1.7.0"  # Change this to the latest version if needed
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz

# Extract and move the binary
tar xvf node_exporter-${VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/

# Set correct permissions
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF


# Reload Systemd and Start the Service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter