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
