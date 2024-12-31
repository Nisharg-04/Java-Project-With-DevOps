#!/bin/bash

############################################
# Author: 	Nisharg Soni
# Date: 	2024-12-30
# Version:	1.0
# Description: Update Ansible inventory
# Usage:	./update-inventory.sh
############################################

TERRAFORM_OUTPUT_DIR="../Terraform"  
ANSIBLE_INVENTORY_DIR="./inventories"
cd "$TERRAFORM_OUTPUT_DIR" || { echo "Terraform directory not found"; exit 1; }

k8s_master_ip=$(terraform output -json k8s_master_ip | jq -r '.')
k8s_worker_1_ip=$(terraform output -json k8s_worker_1_ip | jq -r '.')
k8s_worker_2_ip=$(terraform output -json k8s_worker_2_ip | jq -r '.')
sonarqube_ip=$(terraform output -json sonarqube_ip | jq -r '.')
jenkins_ip=$(terraform output -json jenkins_ip | jq -r '.')
nexus_ip=$(terraform output -json nexus_ip | jq -r '.')
monitoring_ip=$(terraform output -json monitoring_ip | jq -r '.')


update_inventory_file() {
    
    local inventory_file="$1"
    # Create or clear the inventory file
    > "$inventory_file"

    # Write the inventory header
    echo "[k8s_all]" >> "$inventory_file"
    echo "k8s_master ansible_host=$k8s_master_ip" >> "$inventory_file"
    echo "k8s_worker_1 ansible_host=$k8s_worker_1_ip" >> "$inventory_file"
    echo "k8s_worker_2 ansible_host=$k8s_worker_2_ip" >> "$inventory_file"

    echo "[k8s_master]" >> "$inventory_file"
    echo "k8s_master ansible_host=$k8s_master_ip" >> "$inventory_file"

    echo "[k8s_workers]" >> "$inventory_file"
    echo "k8s_worker_1 ansible_host=$k8s_worker_1_ip" >> "$inventory_file"
    echo "k8s_worker_2 ansible_host=$k8s_worker_2_ip" >> "$inventory_file"
    
      

    echo "[sonarqube]" >> "$inventory_file"
    echo "sonarqube ansible_host=$sonarqube_ip" >> "$inventory_file"

    echo "[jenkins]" >> "$inventory_file"
    echo "jenkins ansible_host=$jenkins_ip" >> "$inventory_file"

    echo "[nexus]" >> "$inventory_file"
    echo "nexus ansible_host=$nexus_ip" >> "$inventory_file"

    echo "[monitoring]" >> "$inventory_file"
    echo "monitoring ansible_host=$monitoring_ip" >> "$inventory_file"


    # Add common variables
    echo "" >> "$inventory_file"
    echo "[all:vars]" >> "$inventory_file"
    echo "ansible_user=ubuntu" >> "$inventory_file"
    echo "ansible_ssh_private_key_file=/tmp/devops-key" >> "$inventory_file"
    echo "ansible_ssh_extra_args='-o StrictHostKeyChecking=no'" >> "$inventory_file"
    echo "ansible_python_interpreter=/usr/bin/python3" >> "$inventory_file"

    echo "Updated $env inventory: $inventory_file"
}

# Update each inventory file
cd "../Ansible" || { echo "Ansible directory not found"; exit 1; }

update_inventory_file "$ANSIBLE_INVENTORY_DIR/inventory"



echo "All inventory files updated successfully!"