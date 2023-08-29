#!/bin/bash

pod_file=pod.yaml
cat <<EOF | tee $pod_file
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
EOF

echo "Attempting to create nginx pod"
kubectl create -f $pod_file --kubeconfig global-default-kubeconfig
