variable "location" {
  type        = string
  description = "Azure Region name"
  default     = "westeurope"
}

variable "subnet_config" {
  default = {
    public  = { is_multi_az = false }
    private = { is_multi_az = false }
  }
  description = "Multi az deployment for subnets"
}

variable "name" {
  type        = string
  description = "Generic name, enter your name to identify your resources"
}

variable "aks_node_pool_config" {
  default = {
    default = {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_D2_v2"
    }
  }
}

variable "tags" {
  type        = map(any)
  description = "Tags to identify resources in billing mostly"
  default     = {}
}

variable "charts" {
  type = any
}
