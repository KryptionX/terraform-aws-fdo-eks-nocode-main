# No-Code Module - Terraform Enterprise AWS EKS FDO

## What is this?

This is a No-Code ready module for creating a fully functional K8s cluster on AWS utilizing EKS with Terraform Enterprise FDO based on this [TFC module](https://app.terraform.io/app/hashicorp-support-eng/registry/modules/private/hashicorp-support-eng/fdo-eks/aws).

At this time, no variable configuration is needed to spin up a basic deployment.

## How to deploy

- Open [this module in the Private Registry of our organization](https://app.terraform.io/app/hashicorp-support-eng/registry/modules/private/hashicorp-support-eng/fdo-eks-nocode/aws/), `hashicorp-support-eng` in TFC.
- Click on <ins>Provision Workspace</ins> on the top right.
- Click on <ins>Next: Workspace settings</ins>.
  - Provide a name for your workspace.
  - If desired, select a Project to associate with this workspace.
  - Optionally, enter a description and choose your apply method.
  - Click on <ins>Create workspace</ins> to finalize the setup.
- At this point, your workspace will attempt to plan. It will fail since there are no credentials attached to it via Doormat.
- On your workstation, Run the following commands: _Be sure to replace $WORKSPACE_NAME with the workspace name set in the Workspace settings._
- `doormat login`
- `doormat aws tf-push -a support_terraform_dev -w $WORKSPACE_NAME -o hashicorp-support-eng`
- Now that your credentials are uploaded to the workspace, click start <ins>Start New Run</ins>. _If you need to specify any variables, now would be the time to do so before clicking <ins>Start New Run</ins>._
- Congrats! Your run should be applying at this point.

## Post Deployment

- After the apply operation is finished, the module is set up to show six outputs. These [outputs](#outputs) are marked as steps to complete the cluster configuration.
- Running those commands on your local machine in the numbered order will configure your local access to the Kubernetes cluster and set up the initial admin user for the Terraform Enterprise application.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terraform-enterprise-fdo"></a> [terraform-enterprise-fdo](#module\_terraform-enterprise-fdo) | app.terraform.io/hashicorp-support-eng/fdo-eks/aws | 0.2.0-gamma |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.base-infra](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tag"></a> [tag](#input\_tag) | (REQUIRED) The version of FDO to install. https://developer.hashicorp.com/terraform/enterprise/releases (eg v202309-1) | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_step_1_create_cred_file"></a> [step\_1\_create\_cred\_file](#output\_step\_1\_create\_cred\_file) | Command used to set local AWS cred file that `kubectl` requires for permissions. |
| <a name="output_step_2_update_kubectl"></a> [step\_2\_update\_kubectl](#output\_step\_2\_update\_kubectl) | Command to use to set access to kubectl on local machine. This assumes [default] aws profile credentials are being used, otherwise append --profile <name\_of\_profile>. |
| <a name="output_step_3_get_pods"></a> [step\_3\_get\_pods](#output\_step\_3\_get\_pods) | Command to get the pod name to use . |
| <a name="output_step_4_app_url_initial_admin_user"></a> [step\_4\_app\_url\_initial\_admin\_user](#output\_step\_4\_app\_url\_initial\_admin\_user) | Command to create initial admin user token. |
| <a name="output_step_5_app_url"></a> [step\_5\_app\_url](#output\_step\_5\_app\_url) | TFE app URL. |
<!-- END_TF_DOCS -->
