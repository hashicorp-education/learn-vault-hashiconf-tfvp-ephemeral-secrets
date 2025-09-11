# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# #------------------------------------------------------------------------------
# # Create namespaces: finance, and engineering
# #------------------------------------------------------------------------------
# resource "vault_namespace" "finance" {
#   path = "finance"
# }

# resource "vault_namespace" "engineering" {
#   path = "engineering"
# }

#---------------------------------------------------------------
# Create nested namespaces
#   education has childnamespace, 'training'
#       training has childnamespace, 'secure'
#           secure has childnamespace, 'vault_cloud' and 'boundary'
#---------------------------------------------------------------
# resource "vault_namespace" "education" {
#   path = "education"
# }


# # Create a childnamespace, 'training' under 'education'
# resource "vault_namespace" "training" {
#   namespace = vault_namespace.education.path
#   path      = "training"
# }

# Create a childnamespace, 'vault_cloud' and 'boundary' under 'education/training'
# resource "vault_namespace" "vault_cloud" {
#   namespace = vault_namespace.training.path_fq
#   path      = "vault_cloud"
# }

# # Create 'education/training/boundary' namespace
# resource "vault_namespace" "boundary" {
#   namespace = vault_namespace.training.path_fq
#   path      = "boundary"
# }



# create an accounting namespace
resource "vault_namespace" "accounting" {
  path = "accounting"
}

# create new admin policy for accounting
resource "vault_policy" "accounting_policy" {
  name   = "admins"
  policy = file("policies/admin-policy.hcl")
}

# create new admin policy for accounting
resource "vault_policy" "accounting_app_policy" {
  name   = "app"
  policy = file("policies/accounting-app-policy.hcl")
}

resource "vault_auth_backend" "accounting_approle" {
  depends_on = [vault_namespace.accounting]
  namespace  = vault_namespace.accounting.path_fq
  type       = "approle"
}

# Create a role named, "test-role"
resource "vault_approle_auth_backend_role" "app-role" {
  depends_on     = [vault_auth_backend.accounting_approle, vault_policy.accounting_app_policy]
  backend        = vault_auth_backend.accounting_approle.path
  namespace      = vault_namespace.accounting.path_fq
  role_name      = "test-role"
  token_policies = ["default", "app"]
}

# create secrets engine
# create a kv v2 secrets engine in the accounting namespace
resource "vault_mount" "accounting-kvv2" {
  namespace = vault_namespace.accounting.path
  path      = "kvv2"
  type      = "kv"
  options   = { version = "2" }
}

# create wo secret
# kv v2 secrets in kvv2 in the accounting namespace
# with the data_json_wo argument
resource "vault_kv_secret_v2" "accounting_db_root" {
  namespace = vault_namespace.accounting.path
  mount     = vault_mount.accounting-kvv2.path
  name      = "pgx-root"
   # data_json = jsonencode({"password" = "accounting-admin-password"})
   data_json_wo = jsonencode(
      {
        password = "accounting-admin-password"
      }
   )
   data_json_wo_version = 1
}

# create an ephemeral vault_kv_secret_v2 resource
ephemeral "vault_kv_secret_v2" "accounting_db_secret" {
  namespace = vault_namespace.accounting.path
  mount     = vault_mount.accounting-kvv2.path
  mount_id  = vault_mount.accounting-kvv2.id
  name      = vault_kv_secret_v2.accounting_db_root.name
}

# mount a database secrets engine at the path "postgres"
resource "vault_mount" "account_db" {
  namespace = vault_namespace.accounting.path
  path      = "postgres"
  type      = "database"
}