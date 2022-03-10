#! /usr/bin/env sh
PODID=`kubectl get pods | grep tupress-app | head -1 | cut -d' ' -f 1`
kubectl exec $PODID ls