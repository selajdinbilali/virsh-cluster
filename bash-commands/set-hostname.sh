#!/bin/bash

# List of VM names
vm_names=("doc" "gru" "sne" "snow-white")

# Loop through VM names
for vm_name in "${vm_names[@]}"; do
    # Get the IP address of the VM
    vm_ip=$(virsh domifaddr "$vm_name" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

    # Assign hostname via SSH
    if [ -n "$vm_ip" ]; then
        echo 'sken' | sudo -S sshpass -e ssh -o StrictHostKeyChecking=no sken@"$vm_ip" "sudo hostnamectl set-hostname $vm_name"
        echo "Hostname set for $vm_name with IP: $vm_ip"
    else
        echo "Failed to retrieve IP address for $vm_name"
    fi
done
