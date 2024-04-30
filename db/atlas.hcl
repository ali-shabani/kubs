data "composite_schema" "buynow" {

  schema "public" {
    url = "file://setup"
  }
  schema "public" {
    url = "file://tables"
  }
  schema "public" {
    url = "file://functions"
  }
}

env "local" {
  src = data.composite_schema.buynow.url
  url = "postgres://postgres:postgrespassword@127.0.0.1:5432/buynow?search_path=public&sslmode=disable"
  dev = "docker://postgres/16.2/dev"
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}
