#!/usr/bin/env bash
set -e
# Usage: generate_inventory_from_tfoutput.sh <terraform_dir>
TF_DIR=${1:-terraform}
cd "$TF_DIR"
IP=$(terraform output -raw instance_public_ip)
cat > ../ansible/inventory <<EOF
[web]
${IP} ansible_user=${ANSIBLE_USER:-ec2-user} ansible_port=22
EOF
echo "Inventory created with ${IP}"
