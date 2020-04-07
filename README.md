# terraform-polkadot-do-sentry-node

[![open-issues](https://img.shields.io/github/issues-raw/shinyfoil/terraform-polkadot-do-sentry-node?style=for-the-badge)](https://github.com/shinyfoil/terraform-polkadot-do-sentry-node/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/shinyfoil/terraform-polkadot-do-sentry-node?style=for-the-badge)](https://github.com/shinyfoil/terraform-polkadot-do-sentry-node/pulls)

## Features

This module...

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
    source = "github.com/shinyfoil/terraform-polkadot-do-sentry-node"

}
```
## Examples

- [defaults](https://github.com/shinyfoil/terraform-polkadot-do-sentry-node/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| digitalocean | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Boolean to make module or not | `bool` | `true` | no |
| create\_eip | Boolean to create elastic IP | `bool` | `false` | no |
| environment | The environment | `string` | `""` | no |
| namespace | The namespace to deploy into | `string` | `""` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `""` | no |
| owner | Owner of the infrastructure | `string` | `""` | no |
| region | The DO region to deploy in | `string` | `"nyc1"` | no |
| stage | The stage of the deployment | `string` | `""` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [shinyfoil](github.com/shinyfoil)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.