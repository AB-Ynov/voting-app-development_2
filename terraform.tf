module "network" {
  source = "git@github.com:AB-Ynov/azure_resource_group?ref=v1.0.1"

  location      = var.location
  subnet_config = var.subnet_config
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = format("%s-%s", var.name, terraform.workspace)
  location            = module.network.resource_group.location
  resource_group_name = module.network.resource_group.name
  dns_prefix          = format("%s-%s", var.name, terraform.workspace)

  default_node_pool {
    name       = var.aks_node_pool_config.default.name
    node_count = var.aks_node_pool_config.default.node_count
    vm_size    = var.aks_node_pool_config.default.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# UPDATE YOUR KUBE CONFIG OTHERWISE HELM WILL NOT BE ABLE TO DEPLOY THE CHART 


resource "local_file" "kube_config" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = ".kube/config"
}

resource "helm_release" "chart" {
  for_each         = var.charts
  name             = each.key
  namespace        = each.key
  create_namespace = each.value.create_namespace
  repository       = each.value.repository
  chart            = each.key
  version          = each.value.version

  dynamic "set" {
    for_each = each.value.sets
    content {
      name = set.key
      value = set.value
    }
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    module.network,
    local_file.kube_config
  ]
}
