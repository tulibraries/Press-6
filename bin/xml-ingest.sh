#! /usr/bin/env sh
set -e
export KUBECONFIG="$HOME/.kube/prod-library.yaml"
rancher context switch Tupress
kubectl config set-context --current --namespace=tupress-prod
PODID=`kubectl get pods | grep tupress-app | head -1 | cut -d' ' -f 1`

ingest() {
  # Copy local xml to tupress app
  kubectl cp $1 $PODID:tmp/xml 

  # Ingest
  #kubectl exec $PODID rails sync:pressworks:all[/app/tmp/tupress-delta.xml]
  kubectl exec $PODID ls /app/tmp
}

if [ -d $1 ]; then
  find $1 -name *.xml -exec ingest {} \;
else
  ingest $1
fi

