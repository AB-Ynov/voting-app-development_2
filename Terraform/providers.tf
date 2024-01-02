terraform {

}

provider "azurerm" {
    features {
    }
}

provider "helm" {
  kubernetes {
    config_path = ".kube/config"
  }
}