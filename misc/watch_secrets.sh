#!/bin/bash

for i in {1..10}; do
  echo "Watching secrets request $i for 20 seconds"
  kubectl get --raw "/api/v1/secrets?watch=true&timeoutSeconds=20" --kubeconfig global-default-kubeconfig | wc -c &
done

FAIL=0
for job in `jobs -p`; do
  echo "waiting for job $job"
  wait $job || let "FAIL+=1"
done
echo "Watch failures: $FAIL"
