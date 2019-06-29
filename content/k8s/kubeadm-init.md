---
title: "使用kubedm 安装单节点k8s环境 [国外环境]"
date: 2019-06-29T05:03:35Z
draft: false
---

### 环境及前置操作

[官方文档 - Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

[官方文档 - Creating a single control-plane cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)



#### 环境

* Ubuntu:18.04 1核2G
* kubenetes v1.15.0






## 安装kubeadm,docker,kubectl等相关软件

```Bash
# 添加google仓库源及安装相关软件
apt update && apt install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update && apt install -y kubelet kubeadm kubectl docker.io
systemctl enable docker.service
```



## kubeadm初始化

```Bash
# 初始化
kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU

# 复制配置文件
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络插件
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml

# 使得master节点也能部署服务
kubectl taint nodes --all node-role.kubernetes.io/master-
```

#### 



## 测试运行服务

```Bash
# 创建nginx服务
kubectl create deployment nginx --image=nginx
kubectl create service nodeport nginx --tcp=80:80
```





## 辅助命令

````Bash
# 查看node
kubectl get node
# 查看所有pod状态
kubectl get pods --all-namespaces
````







#### 问题附录

##### 1.默认cpu核心数量限制的问题

```Bash
kubeadm --ignore-preflight-errors=NumCPU
```

##### 2.docker的默认cgroup驱动不是systemd

```Bash
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
systemctl restart docker
```





```bash
images=(  # 下面的镜像应该去除"k8s.gcr.io/"的前缀，版本换成上面获取到的版本
    kube-apiserver:v1.12.1
    kube-controller-manager:v1.12.1
    kube-scheduler:v1.12.1
    kube-proxy:v1.12.1
    pause:3.1
    etcd:3.2.24
    coredns:1.2.2
)

for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
    docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done
```