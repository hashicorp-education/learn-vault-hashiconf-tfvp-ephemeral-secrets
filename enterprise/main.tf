# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# create an accounting namespace

# create secrets engine
# create a kv v2 secrets engine in the accounting namespace
resource "vault_mount" "accounting_kvv2" {
#   namespace = 
  path      = "kvv2"
  type      = "kv"
  options   = { version = "2" }
}

# kv v2 secrets in kvv2 in the accounting namespace
resource "vault_kv_secret_v2" "accounting_db_root" {
#   namespace = 
  mount     = vault_mount.accounting_kvv2.path
  name      = "pgx-root"
   data_json = jsonencode({"password" = "accounting-admin-password"})
   # ...
}

### create an ephemeral vault_kv_secret_v2 resource
# ephemeral "vault_kv_secret_v2" "accounting_db_secret" {
#   namespace = 
#   mount     = 
#   mount_id  = 
#   name      = 
# }
