#!/bin/bash

# Read VM names from the file and start each VM
while IFS= read -r vm_name; do
    virsh start "$vm_name"
done < vm_names.txt
