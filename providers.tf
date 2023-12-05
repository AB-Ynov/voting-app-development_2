terraform {
  required_version = ">=1.3.9"

  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformsimplon"
    container_name       = "states"
    key                  = "networking"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.47.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    config_path = ".kube/config"
  }

  # localhost registry with password protection
  /*registry {
    url = "oci://localhost:5000"
    username = "username"
    password = "password"
  }

  # private registry
  registry {
    url = "oci://private.registry"
    username = "username"
    password = "password"
  }*/
}
