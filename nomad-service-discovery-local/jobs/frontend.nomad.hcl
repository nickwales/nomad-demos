variables {
  ARCH = "arm64"
  OS   = "darwin"
}

job "frontend" {
  type = "service"

  group "frontend" {

    network {
      port "http" { 
        static = 8080
        to     = 8080
      }     
    }

    service {
      provider = "nomad"      
      name     = "frontend"
      port     = "http"

      check {
        name     = "alive"
        type     = "http"
        port     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }


    task "frontend" {
      driver = "raw_exec"

      artifact {
        source = "https://github.com/nicholasjackson/fake-service/releases/download/v0.26.0/fake_service_${var.OS}_${var.ARCH}.zip"
      }

      config {
        command  = "fake-service"
      }

      env {
        NAME        = "frontend"
        MESSAGE     = "This is the frontend"
        LISTEN_ADDR = "0.0.0.0:8080"
      }

      template {
        destination = "local/config.env"
        env         = true
        change_mode = "restart"
        data = <<EOH
{{- range nomadService "backend" -}}
UPSTREAM_URIS = http://{{ .Address }}:{{ .Port }}
{{ end }}
EOH
      }
    } 
  }
}
