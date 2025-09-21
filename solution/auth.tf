# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#--------------------------------
# Enable userpass auth method
#--------------------------------
resource "vault_auth_backend" "acc-userpass" {
   namespace = vault_namespace.accounting.path
   type = "userpass"
}

# Create a user named, "bob"
resource "vault_generic_endpoint" "acc-bob" {
  namespace = vault_namespace.accounting.path
  depends_on           = [vault_auth_backend.acc-userpass]
  path                 = "auth/userpass/users/bob"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "name": "Bob Smith",
  "policies": ["accounting-admin"],
  "password": "training"
}
EOT
}

resource "vault_auth_backend" "edu-userpass" {
   namespace = vault_namespace.education.path
   type = "userpass"
}

# Create a user named, "bob"
resource "vault_generic_endpoint" "edu-bob" {
  namespace = vault_namespace.education.path
  depends_on           = [vault_auth_backend.edu-userpass]
  path                 = "auth/userpass/users/bob"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "name": "Bob Smith",
  "policies": ["accounting-admin"],
  "password": "training"
}
EOT
}