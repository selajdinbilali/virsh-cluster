# this command get all the ips of the runned vms with virsh

virsh list --name | xargs -I {} virsh domifaddr {} | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"