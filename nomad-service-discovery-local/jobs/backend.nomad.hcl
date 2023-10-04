variables {
  ARCH = "arm64"
  OS   = "darwin"
}

job "backend" {
  type = "service"

  group "backend" {

    network {
      port "http" { 
        static = 9090
        to     = 9090
      }     
    }

    service {
      provider = "nomad"      
      name     = "backend"
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


    task "backend" {
      driver = "raw_exec"

      artifact {
        source = "https://github.com/nicholasjackson/fake-service/releases/download/v0.26.0/fake_service_${var.OS}_${var.ARCH}.zip"
      }

      config {
        command  = "fake-service"
      }

      env {
        NAME        = "backend"
        MESSAGE     = "This is the backend"
        LISTEN_ADDR = "0.0.0.0:9090"
      }
    } 
  }
}
