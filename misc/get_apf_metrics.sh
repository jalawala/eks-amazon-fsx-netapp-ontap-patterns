#!/bin/bash

echo "APF APIServer Metrics:"
raw_metrics=$(kubectl get --raw /metrics --kubeconfig kubeconfig)
echo "$raw_metrics" | grep 'executing_requests.*global-default\|inqueue.*global-default\|concurrency_in_use.*global-default\|concurrency_limit.*global-default\|rejected.*global-default\|apiserver_flowcontrol_demand_seats_average.*global-default\|apiserver_storage_objects.*secrets'


echo -e "\nAPF Queue Dump:"
kubectl get --raw '/debug/api_priority_and_fairness/dump_requests?includeRequestDetails=1' --kubeconfig kubeconfig
