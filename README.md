# Terraform Cloudflare KV Test

A test project for Cloudflare Workers KV using the Terraform provider.

## Requirements

- Terraform >= 1.5.7
- Cloudflare Provider 5.13.0 (or local dev build)

## Setup

Put credentials to `terraform.tfvars`:
   ```hcl
   cloudflare_api_token  = "your-api-token"
   cloudflare_account_id = "your-account-id"
   ```

## Using Local Provider

To use a local build of the provider, create `~/.terraform.d/dev.tfrc`:

```hcl
provider_installation {
  dev_overrides {
    "cloudflare/cloudflare" = "/path/to/terraform-provider-cloudflare"
  }
  direct {}
}
```

Then run terraform with:
```bash
TF_CLI_CONFIG_FILE=~/.terraform.d/dev.tfrc terraform plan
TF_CLI_CONFIG_FILE=~/.terraform.d/dev.tfrc terraform apply
```

## Resources Created

- **KV Namespace**: `terraform-test-namespace`
- **KV Keys** (with slashes in names):
  - `config/app/name` → `"my-terraform-app"`
  - `config/app/version` → `"1.0.0"`
  - `users/admin/settings` → `{"notifications":true,"theme":"dark"}`
  - `data/nested/deep/key` → `"deeply nested value"`

## Usage

```bash
# Initialize (skip if using dev overrides)
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Reapply changes
terraform apply

# Destroy resources
terraform destroy
```

## Outputs

- `namespace_id` - The ID of the created KV namespace
- `namespace_title` - The title of the namespace
- `keys_created` - List of KV keys created
