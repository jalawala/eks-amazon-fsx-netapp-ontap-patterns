# eks-amazon-fsx-netapp-ontap-patterns

clone the repo

```bash
cd <working_dir>
git clone https://github.com/jalawala/eks-amazon-fsx-netapp-ontap-patterns.git
```

Create the ArgoCD Admin Secret in AWS Secret Manager

```bash
cd eks-amazon-fsx-netapp-ontap-patterns/argocd-secret
terraform init
terraform plan
terraform apply --auto-approve
```

The output will look like below.

```bash
Outputs:

aws_secret_manager_secret = {
  "arn" = "arn:aws:secretsmanager:us-east-1:000474600478:secret:argocd-admin-secret.eks-fsx-cluster-Xlw3Ll"
  "description" = ""
  "force_overwrite_replica_secret" = false
  "id" = "arn:aws:secretsmanager:us-east-1:000474600478:secret:argocd-admin-secret.eks-fsx-cluster-Xlw3Ll"
  "kms_key_id" = ""
  "name" = "argocd-admin-secret.eks-fsx-cluster"
  "name_prefix" = ""
  "policy" = ""
  "recovery_window_in_days" = 0
  "replica" = toset([])
  "tags" = tomap(null) /* of string */
  "tags_all" = tomap({})
}
aws_secretsmanager_secret_version = <sensitive>
```

Clone the NetApp fsx OnTap Trident Driver Plugin repo

```bash
cd <working_dir>
git clone https://github.com/jalawala/terraform-aws-netapp-fsxn-eks-addon.git
```

Deploy the Stack

```bash
cd eks-amazon-fsx-netapp-ontap-patterns/terraform
terraform init
terraform plan
terraform apply --auto-approve
```


```bash
Apply complete! Resources: 1 added, 1 changed, 0 destroyed.

Outputs:

cluster_endpoint = "https://E41D9B81CC809C80E472543E7C7A94BE.gr7.us-east-1.eks.amazonaws.com"
cluster_security_group_id = "sg-06aae51eded226b3c"
fsx-management-ip = "FSX_MANAGEMENT_IP=198.19.255.142"
fsx-password = "FSX_PASSWORD=EKiy96!L"
fsx-svm-id = "FSX_SVM_ID=svm-0af78ba05a9eee5a9"
fsx-svm-name = "FSX_SVM_NAME=eks-fsx-cluster"
oidc_provider_arn = "arn:aws:iam::000474600478:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/E41D9B81CC809C80E472543E7C7A94BE"
region = "us-east-1"
zz_non_root_volumes_env = "NON_ROOT_VOLUMES=$(aws fsx describe-volumes  --filters Name=storage-virtual-machine-id,Values=svm-0af78ba05a9eee5a9  | jq -r '.Volumes[] | select(.OntapConfiguration.StorageVirtualMachineRoot==false) | .VolumeId')"
zz_update_kubeconfig_command = "aws eks update-kubeconfig --name eks-fsx-cluster --region us-east-1"
jalawala@c889f3a7f83f terraform % 
```

Check if trident driver is installed.

```bash
jalawala@c889f3a7f83f Documents % kubectl get pod -n trident
NAME                                 READY   STATUS    RESTARTS   AGE
trident-controller-dbc8765fc-n7q5v   6/6     Running   0          33m
trident-node-linux-9mvsk             2/2     Running   0          33m
trident-node-linux-bxtqv             2/2     Running   0          33m
trident-node-linux-rdbzx             2/2     Running   0          33m
trident-node-linux-whzmk             2/2     Running   0          33m
trident-operator-6b57b8997c-lqc79    1/1     Running   0          33m
```

```bash
cd <working_dir>
git clone https://github.com/kubernetes-csi/external-snapshotter
cd external-snapshotter/ 
kubectl kustomize client/config/crd | kubectl create -f -

customresourcedefinition.apiextensions.k8s.io/volumesnapshotclasses.snapshot.storage.k8s.io created
customresourcedefinition.apiextensions.k8s.io/volumesnapshotcontents.snapshot.storage.k8s.io created
customresourcedefinition.apiextensions.k8s.io/volumesnapshots.snapshot.storage.k8s.io created


kubectl -n kube-system kustomize deploy/kubernetes/snapshot-controller | kubectl create -f -

serviceaccount/snapshot-controller created
role.rbac.authorization.k8s.io/snapshot-controller-leaderelection created
clusterrole.rbac.authorization.k8s.io/snapshot-controller-runner created
rolebinding.rbac.authorization.k8s.io/snapshot-controller-leaderelection created
clusterrolebinding.rbac.authorization.k8s.io/snapshot-controller-role created
deployment.apps/snapshot-controller created


kubectl kustomize deploy/kubernetes/csi-snapshotter | kubectl create -f - 

serviceaccount/csi-provisioner created
serviceaccount/csi-snapshotter created
role.rbac.authorization.k8s.io/external-provisioner-cfg created
role.rbac.authorization.k8s.io/external-snapshotter-leaderelection created
clusterrole.rbac.authorization.k8s.io/external-provisioner-runner created
clusterrole.rbac.authorization.k8s.io/external-snapshotter-runner created
rolebinding.rbac.authorization.k8s.io/csi-provisioner-role-cfg created
rolebinding.rbac.authorization.k8s.io/csi-snapshotter-provisioner-role-cfg created
rolebinding.rbac.authorization.k8s.io/external-snapshotter-leaderelection created
clusterrolebinding.rbac.authorization.k8s.io/csi-provisioner-role created
clusterrolebinding.rbac.authorization.k8s.io/csi-snapshotter-provisioner-role created
clusterrolebinding.rbac.authorization.k8s.io/csi-snapshotter-role created
service/csi-snapshotter created
statefulset.apps/csi-snapshotter created


```


```bash

export FSX_MANAGEMENT_IP=198.19.255.142
export FSX_PASSWORD=EKiy96!L
export FSX_SVM_NAME=eks-fsx-cluster  

envsubst < manifests/backend-tbc-ontap-nas.tmpl > manifests/backend-tbc-ontap-nas.yaml

kubectl delete -n trident -f manifests/backend-tbc-ontap-nas.yaml
kubectl create -n trident -f manifests/backend-tbc-ontap-nas.yaml

secret/backend-fsx-ontap-nas-secret created
tridentbackendconfig.trident.netapp.io/backend-fsx-ontap-nas created

kubectl get tridentbackendconfig -n trident

backend-fsx-ontap-nas   backend-fsx-ontap-nas   2f4432d8-1236-4a94-bb90-c3949ca94672   Bound   Success

kubectl create ns primary
kubectl create ns secondary

kubectl create -f manifests/storageclass-fsxn-block-nas.yaml 

storageclass.storage.k8s.io/fsx-basic-block-ontap-nas created

kubectl get storageclass 

NAME                        PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
fsx-basic-block-ontap-nas   csi.trident.netapp.io   Delete          Immediate              true                   32s

kubectl create -f manifests/pvc-fsxn-block-nas-primary.yaml 
persistentvolumeclaim/primary-pvc created

kubectl get pvc -n primary

NAME          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                AGE
primary-pvc   Bound    pvc-2ead5b21-be4a-4a3b-a63b-12f2eef7a821   50Gi       RWX            fsx-basic-block-ontap-nas   39s

kubectl get pv -n primary
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS                REASON   AGE
pvc-2ead5b21-be4a-4a3b-a63b-12f2eef7a821   50Gi       RWX            Delete           Bound    primary/primary-pvc   fsx-basic-block-ontap-nas            2m20s

kubectl create -f manifests/pvc-fsxn-block-nas-secondary.yaml 
persistentvolumeclaim/secondary-pvc created

kubectl get pvc -n secondary
NAME            STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS                AGE
secondary-pvc   Pending                                      fsx-basic-block-ontap-nas   25s

kubectl get pv -n secondary
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS                REASON   AGE
pvc-2ead5b21-be4a-4a3b-a63b-12f2eef7a821   50Gi       RWX            Delete           Bound    primary/primary-pvc   fsx-basic-block-ontap-nas            6m41s

kubectl create -f manifests/tvr-in-secondary.yaml 

tridentvolumereference.trident.netapp.io/tvr-in-secondary created


kubectl get TridentVolumeReference -n secondary

NAME               AGE
tvr-in-secondary   63s

kubectl get TridentVolumeReference -n primary

No resources found in primary namespace.

kubectl get tvr -n trident
No resources found in trident namespace.

kubectl get pvc -n secondary

NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                AGE
secondary-pvc   Bound    pvc-d1f1b3bc-45db-43c1-a77f-d03a63e444c6   50Gi       RWX            fsx-basic-block-ontap-nas   21m

kubectl get pv -n secondary
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                     STORAGECLASS                REASON   AGE
pvc-2ead5b21-be4a-4a3b-a63b-12f2eef7a821   50Gi       RWX            Delete           Bound    primary/primary-pvc       fsx-basic-block-ontap-nas            28m
pvc-d1f1b3bc-45db-43c1-a77f-d03a63e444c6   50Gi       RWX            Delete           Bound    secondary/secondary-pvc   fsx-basic-block-ontap-nas            3m12s


```



test

```bash
```

test

```bash
```

test

```bash
```

test

```bash
```
