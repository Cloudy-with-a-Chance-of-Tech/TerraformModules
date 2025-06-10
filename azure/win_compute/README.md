<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.placeholder](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Administrator password for the Windows VM (use Azure Key Vault in production) | `string` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Administrator username for the Windows VM | `string` | `"azureuser"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the VM will be created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the Windows VM (prefix 'vm-' will be added automatically if not present) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the existing resource group where the VM will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size of the Windows VM | `string` | `"Standard_B2s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_location"></a> [location](#output\_location) | Azure region where the VM is located |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | Private IP address of the Windows VM (placeholder) |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address of the Windows VM (placeholder) |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group containing the VM |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | ID of the Windows VM (placeholder) |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | Name of the Windows VM (with prefix applied) |
<!-- END_TF_DOCS -->