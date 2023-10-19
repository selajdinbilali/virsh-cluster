#!/bin/bash

# Read VM names from the file and stop each VM
while IFS= read -r vm_name; do
    virsh undefine "$vm_name"
    rm ../disks/$vm_name.qcow2
done < vm_names.txt