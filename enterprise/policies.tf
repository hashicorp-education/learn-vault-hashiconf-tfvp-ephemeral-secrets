# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Create admin policy in the root namespace
resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("policies/admin-policy.hcl")
}

