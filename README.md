# kids-monitor

Terraform configuration for Grafana Cloud dashboards visualizing the kids'
network activity, sourced from Pi-hole DNS query data pushed to Grafana
Cloud Loki by `network-monitor`'s `data-collector`.

## Overview

This repository manages:
- Grafana Cloud dashboard(s) as code (`grafana_dashboard` resources)

It does not run any application code or provision AWS resources beyond the
Terraform state backend.

## Dashboards

- **Daan Chromebook - DNS Activity** — allowed/blocked DNS query activity
  for Daan's school Chromebook and phone, sourced from the `job="pihole-daan"`
  Loki stream.

## Usage

1. Ensure you're authenticated with AWS: `assume`
2. Initialize Terraform: `terraform -chdir=terraform init`
3. Plan changes: `terraform -chdir=terraform plan`
4. Apply changes: `terraform -chdir=terraform apply`

## Dependencies

This configuration depends on:
- `tf-grafana` (Grafana Cloud stack + `kids_monitor` service account token)
- `network-monitor`'s `data-collector` (pushes the underlying Loki data)

## Outputs

- `daan_chromebook_dashboard_url`: Direct URL to the dashboard
