resource "vault_namespace" "education" {
  path = "education"
}

resource "vault_mount" "education_kvv2" {
   namespace = vault_namespace.education.path
  path      = "kvv2"
  type = "kv"
  options   = { version = "2" }
}

# create wo secret
# kv v2 secrets in kvv2 in the education namespace
# with the data_json_wo argument
resource "vault_kv_secret_v2" "education" {
  namespace = vault_namespace.education.path
  mount     = vault_mount.education_kvv2.path
  name      = "pgx-root"
   data_json = jsonencode({"password" = "education-admin-password"})

}