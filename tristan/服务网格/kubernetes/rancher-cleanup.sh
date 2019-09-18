docker stop $(docer ps -qa)
docker rm -f $(docker ps -qa)
docker volume rm $(docker volume ls -q)
mv /etc/kubernetes /etc/kubernetes-bak-$(date +"%Y%m%d%H%M")
mv /var/lib/etcd /var/lib/etcd-bak-$(date +"%Y%m%d%H%M")
mv /var/lib/rancher /var/lib/rancher-bak-$(date +"%Y%m%d%H%M")
mv /opt/rke /opt/rke-bak-$(date +"%Y%m%d%H%M")
for mount in $(mount  | grep '/var/lib/kubelet' | awk '{ print $3 }') /var/lib/kubelet /var/lib/rancher; do umount $mount; done
rm -rf /etc/ceph \
     /etc/cni \
     /opt/cni \
     /run/secrets/kubernetes.io \
     /run/calico \
     /run/flannel \
     /var/lib/calico \
     /var/lib/cni \
     /var/lib/kubelet \
     /var/log/containers \
     /var/log/pods \
     /var/run/calico
docker ps -a
