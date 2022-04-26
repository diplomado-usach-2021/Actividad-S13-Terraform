resource "azurerm_resource_group" "resource-group" {
  name     = var.name
  location = var.location
  tags = {
    "diplomado" = "diplotag"
  }
}

resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "virtual-network_g2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet_g2"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_kubernetes_cluster" "kubernetesCluster" {
  name                = "kubernetes_g2"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  dns_prefix          = "exampleaks1"
  //kubernetes_version  = "1.19.6"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "standard_d2as_v5"
    vnet_subnet_id      = azurerm_subnet.subnet.id
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
  }

  service_principal {
    client_id     = "dc2faf9e-27ce-412e-8626-ee7c62205b68"
    client_secret = "u.d7Q~qq61NA.s0UB~_c14uKSWlCiw4vQta9j"
  }

  tags = {
    Environment = "developer"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  role_based_access_control_enabled = true

}

resource "azurerm_kubernetes_cluster_node_pool" "clusterNodePool" {
  name                  = "cluster"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetesCluster.id
  vm_size               = "standard_d2as_v5"
  node_count            = 1
  max_pods              = 80

  node_labels = {
   adicional = "adicional"
  }

  tags = {
    Environment = "developer"
  }
}


variable "name" {

}

variable "location" {

}

