# configure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.60.0"
    }
  }
}
# configure provider
provider "azurerm" {
  features {}

}
# creating resource group
resource "azurerm_resource_group" "WT_RG" {
  name     = "${var.prefix}_ResourceGroup"
  location = var.location
}
# network security group
resource "azurerm_network_security_group" "WT_Security" {
  location            = azurerm_resource_group.WT_RG.location
  name                = "${var.prefix}_NSG"
  resource_group_name = azurerm_resource_group.WT_RG.name

}
# virtual network
resource "azurerm_virtual_network" "WT_Network" {
  address_space       = [var.AD-NET]
  location            = azurerm_resource_group.WT_RG.location
  name                = "${var.prefix}_Net"
  resource_group_name = azurerm_resource_group.WT_RG.name
  

}
# Firewall Subnet
resource "azurerm_subnet" "Firewall_Subnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = azurerm_virtual_network.WT_Network.name
  resource_group_name  = azurerm_resource_group.WT_RG.name
  address_prefixes     = [var.FW-Sub]

}
# Firewall Public IP
resource "azurerm_public_ip" "Firewall_PIP" {
  name                = "${var.prefix}_Firewall_PIP"
  allocation_method   = "Static"
  location            = azurerm_resource_group.WT_RG.location
  resource_group_name = azurerm_resource_group.WT_RG.name
  sku                 = "Standard"
}
resource "azurerm_firewall" "WT_Firewall" {
  location            = azurerm_resource_group.WT_RG.location
  name                = "${var.prefix}_Firewall"
  resource_group_name = azurerm_resource_group.WT_RG.name
  ip_configuration {
    name                 = "${var.prefix}_Firewall_ipconfig"
    public_ip_address_id = azurerm_public_ip.Firewall_PIP.id
    subnet_id            = azurerm_subnet.Firewall_Subnet.id
  }

}
# Gateway Public ip 
resource "azurerm_public_ip" "WT_Gateway_PIP" {
  allocation_method   = "Dynamic"
  location            = azurerm_resource_group.WT_RG.location
  name                = "${var.prefix}_Gateway_PIP"
  resource_group_name = azurerm_resource_group.WT_RG.name

}
# Gateway Subnet
resource "azurerm_subnet" "Gatway_Subnet" {
  address_prefixes     = [var.GW-Sub]
  name                 = "GatewaySubnet"
  virtual_network_name = azurerm_virtual_network.WT_Network.name
  resource_group_name  = azurerm_resource_group.WT_RG.name

}
# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "WT_Gateway" {
  name                = "${var.prefix}_Gateway"
  location            = azurerm_resource_group.WT_RG.location
  vpn_type            = "RouteBased"
  type                = "vpn"
  sku                 = "Basic"
  resource_group_name = azurerm_resource_group.WT_RG.name
  ip_configuration {
    public_ip_address_id = azurerm_public_ip.WT_Gateway_PIP.id
    subnet_id            = azurerm_subnet.Gatway_Subnet.id
    
  }
  vpn_client_configuration {
    address_space        = [var.VPN-Pool]
    vpn_client_protocols = ["SSTP"]
    root_certificate {
      name             = "${var.prefix}_root_Cert"
      public_cert_data = var.cert
    }
  }

}
# Virtual machine Subnet
resource "azurerm_subnet" "WT_Sub" {
  name                 = "${var.prefix}_Subnet"
  address_prefixes     = [var.VM-Sub]
  resource_group_name  = azurerm_resource_group.WT_RG.name
  virtual_network_name = azurerm_virtual_network.WT_Network.name
}
# Virtual Machine NIC
resource "azurerm_network_interface" "WT_NIC" {
  name                = "${var.prefix}_NIC"
  location            = azurerm_resource_group.WT_RG.location
  resource_group_name = azurerm_resource_group.WT_RG.name
  ip_configuration {
    name                          = "${var.prefix}_NIC_IPconfig"
    subnet_id                     = azurerm_subnet.WT_Sub.id
    private_ip_address            = var.VM-IP
    private_ip_address_allocation = "Static"


  }
}
# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "WT_VM" {
  name                  = "WatchTower"
  location              = azurerm_resource_group.WT_RG.location
  network_interface_ids = [azurerm_network_interface.WT_NIC.id]
  resource_group_name   = azurerm_resource_group.WT_RG.name
  size                  = "Standard_F2"
  admin_password        = var.pass
  admin_username        = var.user
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"


  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"

  }
}
