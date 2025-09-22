resource "vault_namespace" "education" {
  path = "education"
}

resource "vault_mount" "education_kvv2" {
   namespace = vault_namespace.education.path
  path      = "kvv2"
  type = "kv"
  options   = { version = "2" }
}

resource "vault_kv_secret_v2" "education" {
  namespace = vault_namespace.education.path
  mount     = vault_mount.education_kvv2.path
  name      = "pgx-root"
   data_json = jsonencode({"password" = "education-admin-password"})

}