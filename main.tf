terraform {
  required_version = ">= 1.5.7"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.13.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
  sensitive   = true
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

# Create a KV Namespace
resource "cloudflare_workers_kv_namespace" "test_namespace" {
  account_id = var.cloudflare_account_id
  title      = "terraform-test-namespace"
}

# KV pairs with slashes in the keys
resource "cloudflare_workers_kv" "config_app_name" {
  account_id   = var.cloudflare_account_id
  namespace_id = cloudflare_workers_kv_namespace.test_namespace.id
  key_name     = "config/app/name"
  value        = "my-terraform-app"
}

resource "cloudflare_workers_kv" "config_app_version" {
  account_id   = var.cloudflare_account_id
  namespace_id = cloudflare_workers_kv_namespace.test_namespace.id
  key_name     = "config/app/version"
  value        = "1.0.0"
}

resource "cloudflare_workers_kv" "users_admin_settings" {
  account_id   = var.cloudflare_account_id
  namespace_id = cloudflare_workers_kv_namespace.test_namespace.id
  key_name     = "users/admin/settings"
  value        = jsonencode({
    theme = "dark"
    notifications = true
  })
}

resource "cloudflare_workers_kv" "data_nested_deep_key" {
  account_id   = var.cloudflare_account_id
  namespace_id = cloudflare_workers_kv_namespace.test_namespace.id
  key_name     = "data/nested/deep/key"
  value        = "deeply nested value"
}

# Outputs
output "namespace_id" {
  value       = cloudflare_workers_kv_namespace.test_namespace.id
  description = "The ID of the created KV namespace"
}

output "namespace_title" {
  value       = cloudflare_workers_kv_namespace.test_namespace.title
  description = "The title of the created KV namespace"
}

output "keys_created" {
  value = [
    cloudflare_workers_kv.config_app_name.key_name,
    cloudflare_workers_kv.config_app_version.key_name,
    cloudflare_workers_kv.users_admin_settings.key_name,
    cloudflare_workers_kv.data_nested_deep_key.key_name,
  ]
  description = "List of KV keys created"
}
