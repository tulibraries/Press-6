#! /usr/bin/env sh
set -e


export KUBECONFIG="$HOME/.kube/prod-library.yaml"

rancher context switch Tupress
kubectl config set-context --current --namespace=tupress-prod
PODID=`kubectl get pods | grep tupress-app | head -1 | cut -d' ' -f 1`

ingest() {
  # Copy local xml to tupress app
  echo path $1

  kubectl cp $1 $PODID:tmp/books.xml

  # Ingest
  kubectl exec $PODID rails sync:pressworks:all[/app/tmp/books.xml]
}

if [ -d $1 ]; then
  for file in $(find $1 -name "*.xml")
  do
    ingest $file
  done
else
  ingest $1
fi

