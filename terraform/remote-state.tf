data "terraform_remote_state" "tf_grafana" {
  backend = "s3"

  config = {
    bucket = "mdekort-tfstate-075673041815"
    key    = "tf-grafana.tfstate"
    region = "eu-west-1"
  }
}
