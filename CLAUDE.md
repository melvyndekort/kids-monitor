# kids-monitor

> For global standards, way-of-workings, and pre-commit checklist, see `~/.claude/CLAUDE.md`

## Role

Cloud Engineer specializing in Terraform and Grafana Cloud.

## What This Does

Dashboard-as-code for the kids' network activity, currently just Daan's
Chromebook DNS activity (allowed vs. blocked, sourced from Pi-hole via
`network-monitor`'s `data-collector`). No app code, no AWS resources beyond
the Terraform state backend.

## Repository Structure

- `terraform/providers.tf` — Grafana provider (auth via `tf-grafana` remote
  state output), S3 backend
- `terraform/remote-state.tf` — `tf_grafana` remote state data source
- `terraform/grafana-dashboard.tf` — the dashboard resource(s)
- `terraform/outputs.tf` — dashboard URL(s)
- `Makefile` — `init`, `plan`, `apply`, `fmt`

## Terraform Details

- Backend: S3 key `kids-monitor.tfstate` in `mdekort-tfstate-075673041815`
- Providers: Grafana `~> 4.8`
- No local secrets — Grafana auth comes entirely from `tf-grafana`'s
  `kids_monitor_token` output.

## Data Source

Dashboards query the Grafana Cloud Loki datasource (`grafanacloud-logs`,
UID hardcoded as a local in `grafana-dashboard.tf` — this is the same Loki
instance `vector` already pushes syslog to). The `job="pihole-daan"` stream
is pushed by `network-monitor`'s `data-collector` (`pihole.py` client),
labels: `job`, `device` (`chromebook`/`phone`), `result`
(`allowed`/`blocked`); log line body carries the domain as JSON.

## MCP servers

This repo has a project-scoped `grafana` MCP server (`.mcp.json`) — see `~/.claude/references/mcp-catalog.md`.

## Related Repositories

- `~/src/melvyndekort/tf-grafana` — Provides Grafana URL + service account
  token
- `~/src/melvyndekort/network-monitor` — `data-collector`'s `pihole.py`
  produces the data this dashboard visualizes
