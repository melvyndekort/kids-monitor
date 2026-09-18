output "daan_chromebook_dashboard_url" {
  value = "${data.terraform_remote_state.tf_grafana.outputs.grafana_url}/d/${grafana_dashboard.daan_chromebook.uid}"
}
