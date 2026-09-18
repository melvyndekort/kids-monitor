terraform {
  required_version = "~> 1.10"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 4.8"
    }
  }

  backend "s3" {
    bucket       = "mdekort-tfstate-075673041815"
    key          = "kids-monitor.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "grafana" {
  url  = data.terraform_remote_state.tf_grafana.outputs.grafana_url
  auth = data.terraform_remote_state.tf_grafana.outputs.kids_monitor_token
}
