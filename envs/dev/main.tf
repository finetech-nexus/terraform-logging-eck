terraform {
  cloud {
    organization = "fintech-nexus"

    workspaces {
      name = "logging-dev"
    }
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

locals {
  name        = "elastic"
  region      = ""
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}


module "eck" {
  source    = "fintech-nexus/terraform-logging-eck/logging"
  version   = "1.0.0"
  namespace = "elastic-system"
  eck_config = {
    provider_type        = "local"
    eck_values           = file("./helm/eck.yaml")
    master_node_sc       = "gp2"
    data_hot_node_sc     = "gp2"
    data_warm_node_sc    = "gp2"
    master_node_size     = "20Gi"
    data_hot_node_size   = "50Gi"
    data_warm_node_size  = "50Gi"
    kibana_node_count    = 1
    master_node_count    = 1
    data_hot_node_count  = 2
    data_warm_node_count = 2
  }
  exporter_enabled   = true
  elastalert_enabled = false
  elastalert_config = {
    slack_webhook_url = ""
    elastalert_values = file("./helm/elastAlert.yaml")
  }
}
