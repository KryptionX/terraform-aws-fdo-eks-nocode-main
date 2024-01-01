############################################################
# Pulls data from base-infra Terrafrom Cloud workspace     #
############################################################

data "terraform_remote_state" "base-infra" {
  backend = "remote"

  config = {
    organization = "hashicorp-support-eng"
    workspaces = {
      name = "terraform-team-base-infrastructure"
    }
  }
}

############################################################
# Sets locals from base-infra                              #
############################################################

locals {
  base-infra = data.terraform_remote_state.base-infra.outputs
}

############################################################
# TFE AWS EKS FDO Module                                   #
############################################################

module "terraform-enterprise-fdo" {
  source    = "app.terraform.io/hashicorp-support-eng/fdo-eks/aws"
  version   = "0.2.1"
  zone_name = local.base-infra.zone_name
  tag       = var.tag
}

############################################################
# Outputs                                                  #
############################################################

output "step_1_create_cred_file" {
  description = "Command used to set local AWS cred file that `kubectl` requires for permissions."
  value       = "doormat aws cred-file add-profile --set-default -a support_terraform_dev"
}

output "step_2_update_kubectl" {
  description = "Command to use to set access to kubectl on local machine. This assumes [default] aws profile credentials are being used, otherwise append --profile <name_of_profile>."
  value       = "aws eks --region us-east-1 update-kubeconfig --name ${module.terraform-enterprise-fdo.cluster_name}"
}

output "step_3_get_pods" {
  description = "Command to get the pod name to use ."
  value       = "export POD=$(kubectl get pods -n terraform-enterprise -o jsonpath='{.items[*].metadata.name}')"
}

output "step_4_app_url_initial_admin_user" {
  description = "Command to create initial admin user token."
  value       = "export IACT=$(kubectl exec -t -n terraform-enterprise $POD -- bash -c \"/usr/local/bin/retrieve-iact\") && echo \"https://${module.terraform-enterprise-fdo.random_pet}.${local.base-infra.zone_name}/admin/account/new?token=$IACT\""
}

output "step_5_app_url" {
  description = "TFE app URL."
  value       = "https://${module.terraform-enterprise-fdo.random_pet}.${local.base-infra.zone_name}"
}
