locals {
  loki_uid = "grafanacloud-logs"
}

resource "grafana_dashboard" "daan_chromebook" {
  config_json = jsonencode({
    id       = null
    title    = "Daan Chromebook - DNS Activity"
    tags     = ["pihole", "parental-controls", "daan"]
    timezone = "browser"

    panels = [
      # Row 1 - at a glance
      {
        id         = 1
        title      = "Queries today"
        type       = "stat"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr         = "sum(count_over_time({job=\"pihole-daan\"}[$__range]))"
            legendFormat = "queries"
            refId        = "A"
            instant      = true
          }
        ]
        gridPos = { h = 4, w = 6, x = 0, y = 0 }
      },
      {
        id         = 2
        title      = "Blocked vs Allowed"
        type       = "piechart"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr         = "sum by (result) (count_over_time({job=\"pihole-daan\"}[$__range]))"
            legendFormat = "{{result}}"
            refId        = "A"
            instant      = true
          }
        ]
        gridPos = { h = 8, w = 6, x = 6, y = 0 }
      },
      {
        id         = 3
        title      = "Distinct blocked domains today"
        type       = "stat"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr         = "count(count by (domain) (count_over_time({job=\"pihole-daan\", result=\"blocked\"} | json [$__range])))"
            legendFormat = "domains"
            refId        = "A"
            instant      = true
          }
        ]
        gridPos = { h = 4, w = 6, x = 12, y = 0 }
      },
      {
        id         = 4
        title      = "Last activity"
        type       = "logs"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr  = "{job=\"pihole-daan\"}"
            refId = "A"
          }
        ]
        options = {
          showTime         = true
          sortOrder        = "Descending"
          enableLogDetails = false
        }
        gridPos = { h = 4, w = 6, x = 18, y = 0 }
      },

      # Row 2 - timeline
      {
        id         = 5
        title      = "Query volume over time"
        type       = "timeseries"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr         = "sum by (result) (count_over_time({job=\"pihole-daan\"}[$__interval]))"
            legendFormat = "{{result}}"
            refId        = "A"
          }
        ]
        fieldConfig = {
          defaults = {
            custom = { stacking = { mode = "normal" } }
          }
        }
        gridPos = { h = 8, w = 24, x = 0, y = 4 }
      },

      # Row 3 - what he's trying
      {
        id         = 6
        title      = "Top blocked domains"
        type       = "table"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr    = "topk(15, sum by (domain) (count_over_time({job=\"pihole-daan\", result=\"blocked\"} | json [$__range])))"
            format  = "table"
            refId   = "A"
            instant = true
          }
        ]
        gridPos = { h = 8, w = 8, x = 0, y = 12 }
      },
      {
        id         = 7
        title      = "Newest blocked (live feed)"
        type       = "logs"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr  = "{job=\"pihole-daan\", result=\"blocked\"}"
            refId = "A"
          }
        ]
        options = {
          showTime  = true
          sortOrder = "Descending"
        }
        gridPos = { h = 8, w = 8, x = 8, y = 12 }
      },
      {
        id         = 8
        title      = "Possible allowlist gaps"
        type       = "logs"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr  = "{job=\"pihole-daan\", result=\"blocked\"} | json | domain=~\".*(office|microsoft|magister|sharepoint|teams).*\""
            refId = "A"
          }
        ]
        options = {
          showTime  = true
          sortOrder = "Descending"
        }
        gridPos = { h = 8, w = 8, x = 16, y = 12 }
      },
      {
        id         = 9
        title      = "Top allowed domains"
        type       = "table"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr    = "topk(15, sum by (domain) (count_over_time({job=\"pihole-daan\", result=\"allowed\"} | json [$__range])))"
            format  = "table"
            refId   = "A"
            instant = true
          }
        ]
        gridPos = { h = 8, w = 24, x = 0, y = 20 }
      },

      # Row 4 - per device
      {
        id         = 10
        title      = "Per-device breakdown"
        type       = "bargauge"
        datasource = { type = "loki", uid = local.loki_uid }
        targets = [
          {
            expr         = "sum by (device, result) (count_over_time({job=\"pihole-daan\"}[$__range]))"
            legendFormat = "{{device}} - {{result}}"
            refId        = "A"
            instant      = true
          }
        ]
        gridPos = { h = 8, w = 24, x = 0, y = 28 }
      }
    ]

    time = {
      from = "now-24h"
      to   = "now"
    }
    refresh = "1m"
  })
}
