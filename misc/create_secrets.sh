#!/bin/bash

create_secrets() {
  for i in $(seq 5000); do
    kubectl create secret generic "secret$1-$i" --from-literal=username=example --kubeconfig kubeconfig
  done
}

for i in {1..10}; do
   create_secrets $i &
done
