# Get the latest PostgreSQL image
resource "docker_image" "postgres" {
  name = "postgres:latest"
}

# Start a PostgreSQL container
resource "docker_container" "postgres" {
  name  = "learn-postgres"
  image = docker_image.postgres.image_id
  env  = ["POSTGRES_USER=postgres", "POSTGRES_PASSWORD=accounting-admin-password"]
  ports {
    internal = 5432
    external = 5432
  }
  rm = true
}

# Add a sleep resource to wait for the PostgreSQL container to be ready
resource "time_sleep" "wait_7_seconds" {
  depends_on      = [docker_container.postgres]
  create_duration = "7s"
}

# mount a database secrets engine at the path "postgres"
resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

# create a database role for the postgres database with a
# PostgreSQL Configuration option that uses the password_wo
# to set the password
resource "vault_database_secret_backend_connection" "accounting-postgres" {
  depends_on    = [time_sleep.wait_7_seconds]
  backend       = vault_mount.db.path
  name          = docker_container.postgres.name
  allowed_roles = ["*"]

  postgresql {
    connection_url          = "postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable"
    password_authentication = ""
    username                = "postgres"
    password_wo             = tostring(ephemeral.vault_kv_secret_v2.accounting_db_secret.data.password)
    password_wo_version = 1
    # password            = tostring(vault_kv_secret_v2.accounting_db_root.data.password)
  }
}