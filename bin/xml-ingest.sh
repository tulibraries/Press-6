#! /usr/bin/env sh
export KUBECONFIG="$HOME/.kube/prod-library.yaml"
rancher context switch Tupress
kubectl config set-context --current --namespace=tupress-prod
PODID=`kubectl get pods | grep tupress-app | head -1 | cut -d' ' -f 1`

# Copy local xml to tupress app
kubectl cp $1 $PODID:tmp/xml 

# Ingest
#kubectl exec $PODID rails sync:pressworks:all[/app/tmp/xml]
kubectl exec ls /app/tmp
