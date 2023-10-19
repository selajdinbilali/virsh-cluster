#!/bin/bash

# Base VM name and disk image
base_vm_name="debian12-base"
base_vm_disk="/var/lib/libvirt/images/debian12-base.qcow2"


# Clone the base VM and customize network settings
while IFS= read -r vm_name; do
    # Clone the VM
    virt-clone --original "$base_vm_name" --name "$vm_name" --file "/home/bilali/Learn/virsh-cluster/disks/$vm_name.qcow2"
done < vm_names.txt
