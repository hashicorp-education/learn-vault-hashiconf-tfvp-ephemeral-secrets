# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# create an accounting namespace
resource "vault_namespace" "accounting" {
  path = "accounting"
}

# create secrets engine
# create a kv v2 secrets engine in the accounting namespace
resource "vault_mount" "accounting_kvv2" {
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
  mount     = vault_mount.accounting_kvv2.path
  name      = "pgx-root"
   # data_json = jsonencode({"password" = "accounting-admin-password"})
   data_json_wo = jsonencode({password = "accounting-admin-password"})
   data_json_wo_version = 1
}

## create an ephemeral vault_kv_secret_v2 resource
ephemeral "vault_kv_secret_v2" "accounting_db_secret" {
  namespace = vault_namespace.accounting.path
  mount     = vault_mount.accounting_kvv2.path
  mount_id  = vault_mount.accounting_kvv2.id
  name      = vault_kv_secret_v2.accounting_db_root.name
}