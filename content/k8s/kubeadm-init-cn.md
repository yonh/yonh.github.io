---
title: "使用kubedm安装双节点k8s集群 [国内环境]"
date: 2019-07-15T01:03:35Z
draft: false
---

### 环境及前置操作

[官方文档 - Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

[官方文档 - Creating a single control-plane cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

[同步K8S镜像代码](https://github.com/yonh/sync_k8s_docker_images)

[同步Kubernetes Ubuntu包代码](https://github.com/yonh/k8s_package_sync)

镜像仓库: [DockerHub](https://hub.docker.com/u/yonh), [网易云](https://c.163yun.com/hub#/m/user/?name=yonh92)





#### 环境

* Ubuntu:18.04 2核2G master
* Ubuntu:18.04 2核2G node
* kubenetes v1.15.0
* Virtualbox + Vagrant
* Kubernetes: v1.5.0
* Kubernetes网络组件: flannel




#### 文章视频

<iframe width="100%" height="500" src="https://www.youtube.com/embed/q71aee6ul1E" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>







## 整体安装过程示意图

[图片原文档下载](/k8s/init-k8s-in-china.drawio)

![](images/000.jpg)









## 创建虚拟机

创建Vagrantfile

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  servers = [
      {
          :hostname => "k8s-master",
          :ip => "192.168.100.10",
          :box => "ubuntu/bionic64",
          :ram => 2048,
          :cpu => 2
      },
      {
          :hostname => "k8s-node",
          :ip => "192.168.100.11",
          :box => "ubuntu/bionic64",
          :ram => 2048,
          :cpu => 2
      }
  ]

  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      node.vm.network "private_network", ip: machine[:ip]
      node.vm.provider "virtualbox" do |vb|
        vb.name = machine[:hostname]
        vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
      end
    end
  end
end
```



## 安装kubeadm,docker,kubectl等相关软件

**这一步是 `master,node`节点都需要执行**

```Bash
# 更改为国内源(可选)
cat <<EOF > /etc/apt/sources.list
deb https://mirrors.163.com/ubuntu/ bionic main
deb https://mirrors.163.com/ubuntu/ bionic-updates main
deb https://mirrors.163.com/ubuntu/ bionic universe
#deb https://mirrors.163.com/ubuntu/ bionic-updates universe
#deb https://mirrors.163.com/ubuntu/ bionic-security main
#deb https://mirrors.163.com/ubuntu/ bionic-security universe
EOF

cat <<EOF > /etc/apt/sources.list
deb https://mirrors.aliyun.com/ubuntu/ bionic main
deb https://mirrors.aliyun.com/ubuntu/ bionic-updates main
deb https://mirrors.aliyun.com/ubuntu/ bionic universe
#deb https://mirrors.aliyun.com/ubuntu/ bionic-updates universe
#deb https://mirrors.aliyun.com/ubuntu/ bionic-security main
#deb https://mirrors.aliyun.com/ubuntu/ bionic-security universe
EOF


#### 添加google仓库源的国内同步源及安装相关软件
# 添加apt-key
#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg |apt-key add -

# 添加仓库源
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
#deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main
deb http://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
EOF

# 安装相关组件
apt update && apt install -y kubelet kubeadm kubectl docker.io
# 启用默认启动docker服务
systemctl enable docker.service
```



## kubeadm初始化

由于我这里同步了k8s的软件包，你可以直接直接配置参数`repository=hub.c.163.com/yonh92`来使用我同步的镜像，当然你也可以自己同步镜像，我这里写了同步脚本 https://github.com/yonh/sync_k8s_docker_images

```Bash
# 以下命令在Master节点执行

# 可以用这个命令查看依赖的docker镜像
# kubeadm config images list

# 初始化
kubeadm init --apiserver-advertise-address=192.168.100.10 --image-repository=hub.c.163.com/yonh92 --pod-network-cidr=10.244.0.0/16
# --apiserver-advertise-address=192.168.100.10
# 配置apiserver地址,这个地址跟随你的master节点而定
# --image-repository=hub.c.163.com/yonh92
# 配置镜像仓库地址，因为我们访问不了k8s.gcr.io, kubeadm提供了设置镜像仓库地址，所以我们可以使用此参数绕过它，不从k8s.gcr.io下载，从我们配置的仓库地址下载
# --pod-network-cidr=10.244.0.0/16
# 我们的网络插件选择flannel，根据flannel的要求配置的，没什么好说的
```



接下来等待一段时间初始化OK了之后,我们会看到类似这样的说明

上面的3行(`mkdir那行`)是拷贝一些配置文件，让kubectl可以操作集群，照做就是了

下面长长的`kubeadm join`命令就是在`node节点`用来加入集群的操作

![001](images/001.png)



接下来在`Master节点`执行下面的语句


```bash
# 复制配置文件
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络插件
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml


# 使得master节点也能部署服务 [可选]
kubectl taint nodes --all node-role.kubernetes.io/master-
```



在`Node节点`执行命令加入集群

```bash
# 节点加入集群，不要拷贝我的，用kubeadm生成的
kubeadm join 192.168.100.10:6443 --token o95w4x.tw5i6kcwmanq3r6b \
    --discovery-token-ca-cert-hash sha256:1fce6909a8bc4d0e8c46cf19bf607bcf5bbdad67679587e14870e3f82007f83e
```



#### 查看节点状态 

现在执行`kubectl get node`可以看到2个节点都是NotReady状态

![](images/002.png)

如果没问题，等待一会儿就会好的，就像这样

![](images/003.png)

在此过程中，可以使用命令`kubectl get pod --all-namespaces`查看容器状态

![](images/004.png)



## 测试运行服务

```Bash
# 创建nginx服务
kubectl create deployment nginx --image=nginx
kubectl create service nodeport nginx --tcp=80:80
```

![](images/005.png)



## 辅助命令

````Bash
# 查看node
kubectl get node
# 查看services
kubectl get svc
# 查看所有pod状态
kubectl get pods --all-namespaces
# 查看依赖镜像
kubeadm config images list
# 查看所有pod及其相应的节点
kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName --all-namespaces
````

