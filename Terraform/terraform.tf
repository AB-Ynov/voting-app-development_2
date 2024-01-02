resource "azurerm_resource_group" "rg" {
  name     = "rg"
  location = "France Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kube_config" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = ".kube/config"
}

resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress-controller"
  namespace        = "nginx-ingress-controller"
  create_namespace = true
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx-ingress-controller"
  version          = "9.4.1"

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.kube_config
  ]
}

resource "helm_release" "redis" {
  name             = "redis"
  namespace        = "redis"
  create_namespace = true
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "redis"
  version          = "v17.9.2"

  set {
    name  = "global.redis.password"
    value = "plop"
  }

  set {
    name  = "replica.replicaCount"
    value = 1
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.kube_config
  ]
}

resource "helm_release" "vote-app" {
  name             = "vote-app"
  namespace        = "vote-app"
  create_namespace = true
  chart            = "../Helm/vote-app-deployment"

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.kube_config,
    helm_release.redis,
    helm_release.nginx_ingress
  ]
}

resource "helm_release" "vote-app-canary" {
  name             = "vote-app-canary"
  namespace        = "vote-app-canary"
  create_namespace = true
  chart            = "../Helm/vote-app-canary"

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.kube_config,
    helm_release.redis,
    helm_release.nginx_ingress
  ]
}