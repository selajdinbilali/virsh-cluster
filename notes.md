

# Virsh cluster
## install virt-manager

        $ sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils -y
        sudo systemctl start libvirtd
        sudo adduser $USER libvirt
        sudo systemctl restart libvirtd
        reboot

# debian base image for all
- ram 2048 cpu 2 disk 8 GiB
- create it without swap
- add user as sudo
- install ssh key of host
- install docker and kubernetes

        sudo apt install ufw

## install containerd (https://computingforgeeks.com/install-kubernetes-cluster-on-debian-12-bookworm/)

        sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/debian.gpg
        sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

        sudo apt update
        sudo apt install -y containerd.io

        sudo mkdir -p /etc/containerd
        containerd config default | sudo tee /etc/containerd/config.toml

        sudo systemctl restart containerd
        sudo systemctl enable containerd

        sudo systemctl enable kubelet
        sudo kubeadm config images pull

        sudo kubeadm init --pod-network-cidr=192.168.89.0/16

        sudo ufw allow 6443/tcp

        mkdir -p $HOME/.kube
        sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config

# add hosts in /etc/ansible/hosts

    [mynodes]
    192.168.122.91

# copy ssh key to base node manually
    connect to node
    mkdir ~/.ssh
    cd ~/.ssh
    nano authorized_keys
    paste ssh pub key
    chmod -R go= ~/.ssh
    # go
    sudo nano /etc/ssh/sshd_config
    # uncomment
    PasswordAuthentication no
    sudo systemctl restart ssh


# add user as sudo

    su -
    apt-update
    apt install sudo -y
    exit
    sudo -s
    su -
    usermod -aG sudo <username>
    exit
    exit and re-ssh


# ping nodes
first there will be an error
you need python 3 to all your nodes
insure that your base vm has python 3

        ansible mynodes -m ping
        ansible -i ./inventory/hosts -m ping



# todo

# install docker and kubernetes on each node

# configure the master node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

## kubeadm error, also in workers
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
kubeadm join 192.168.122.91:6443 --token z14h6e.7uk76awzv3lpcu2i \
	--discovery-token-ca-cert-hash sha256:90ecd7088ca836ec96bc58afeb7e41275ac54175a13e1995cdadba9be3f368d7




# join the workers to the cluster



# workflow

1. create-cluster.sh
2. start-existing-cluster.sh
3. get ip of master and place it in [masters] of inventory/hosts
3. sudo hostnamectl set-hostname newhostname
3. sudo systemctl restart hostname
4. setup-master.yml
5. set hostname of worker
6. add-worker.yml

## ansible for ubuntu like

        $ sudo apt update
        $ sudo apt install software-properties-common
        $ sudo add-apt-repository --yes --update ppa:ansible/ansible
        $ sudo apt install ansible