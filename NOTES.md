* Shortcut for cloning repository on vagrant machine:

  sudo yum install -y git && git clone https://github.com/piotroramus/net-policy-exercise.git

* I cannot get contiv working with kubernetes services hostname resolution

** When pods do not have any contiv labels assigned - does not work, but either way it uses contiv network
** The default policy is not suitable when running mongo on master node? - no, because when I run mongo on the same node it is doesn't work nether...
** Maybe this has something to do with a tenant...? - nope, doesn't work without tenants neither
** It works on local k8s cluster (so without contiv)
** I don't know how to fix kubedns - in fact it is being encouraged to completely turn it of
   https://github.com/contiv/netplugin/tree/master/install/k8s
   https://github.com/contiv/netplugin/commit/1146f6875894706998d2d671aaa730e5e92f1726
** Deploying new contiv release (1.1.8) doesn't work (missing packages)
** VLAN mode only doesn't' change anything
** If really desperate I could have a look at https://kubernetes.io/docs/concepts/services-networking/service/ and see how the iptables are set up
