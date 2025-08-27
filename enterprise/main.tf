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

# create a kv v2 secrets engine in the root namespace
resource "vault_mount" "kvv2" {
  path    = "my-kvv2"
  type    = "kv"
  options = { version = "2" }
}

# mount a database secrets engine at the path "postgres"
resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

