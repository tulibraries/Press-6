#! /usr/bin/env sh
set -e

# Switches Kubernetes context to production
# Assumes production Kube Config file is "$HOME/.kube/prod-library.yaml"
# Iterates over xml files found in given path
# Copies files to Kubernetes tupress-app pod
# Runs the rails sync:pressworks task

export KUBECONFIG="$HOME/.kube/prod-library.yaml"

rancher context switch Tupress
kubectl config set-context --current --namespace=tupress-prod
PODID=`kubectl get pods | grep tupress-app | head -1 | cut -d' ' -f 1`

ingest() {
  # Copy local xml to tupress app
  echo path $1

  kubectl cp -c tupress-app $1 $PODID:tmp/books.xml

  # Ingest
  kubectl exec -c tupress-app $PODID rails sync:pressworks:all[/app/tmp/books.xml]
}

if [ -d $1 ]; then
  for file in $(find $1 -name "*.xml" | sort)
  do
    ingest $file
  done
else
  ingest $1
fi

