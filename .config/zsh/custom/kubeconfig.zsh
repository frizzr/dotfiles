export KUBECONFIG=~/.kube/config:${(j|:|)$(ls ~/.kube/*.kfg)}
