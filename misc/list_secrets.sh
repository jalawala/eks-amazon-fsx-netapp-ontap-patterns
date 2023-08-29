#!/bin/bash

while true; do
  for i in {1..10}; do
    echo "Listing secrets request $i"
    kubectl get --raw "/api/v1/secrets" --kubeconfig global-default-kubeconfig | wc -c &
  done

  FAIL=0
  for job in `jobs -p`; do
    echo "waiting for job $job"
    wait $job || let "FAIL+=1"
  done
  echo "List failures: $FAIL"
done
