# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#---------------------
# Create policies
#---------------------

# Create admin policy in the root namespace
resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("policies/admin-policy.hcl")
}

# Create admin policy in the finance namespace
resource "vault_policy" "admin_policy_accounting" {
  namespace = vault_namespace.accounting.path
  name      = "accounting-admin"
  policy    = file("policies/admin-policy.hcl")
}

# Create admin policy in the education namespace
resource "vault_policy" "admin_policy_education" {
  namespace = vault_namespace.education.path
  name      = "education-admin"
  policy    = file("policies/admin-policy.hcl")
}