#!/bin/bash

# Read VM names from the file and stop each VM
while IFS= read -r vm_name; do
    virsh undefine "$vm_name"
done < vm_names.txt