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
