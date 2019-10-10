# Provisions infrastructure required for Lab-Scorer Application

#############################################
# Resource Group
#############################################

resource "azurerm_resource_group" "lab-scorer" {
    name            = "lab-scorer"
    location        = "eastus"
}

#############################################
# Container Registry
#############################################

resource "azurerm_container_registry" "lab-scorer" {
    name                     = "labScorerRegistry"
    resource_group_name      = azurerm_resource_group.lab-scorer.name
    location                 = azurerm_resource_group.lab-scorer.location
    sku                      = "Basic"
}

#############################################
# Backend 
#############################################

resource "azurerm_cosmosdb_account" "lab-scorer" {
    name                    = "lab-scorer-be"
    resource_group_name     = azurerm_resource_group.lab-scorer.name
    location                = azurerm_resource_group.lab-scorer.location

    offer_type              = "Standard"
    kind                    = "MongoDB"

    consistency_policy {
        consistency_level   = "BoundedStaleness"
    }

    geo_location {
        location            = azurerm_resource_group.lab-scorer.location
        failover_priority   = 0
    }
}

#############################################
# Frontend
#############################################

resource "azurerm_container_group" "lab-scorer" {
    name                    = "lab-scorer"
    resource_group_name     = azurerm_resource_group.lab-scorer.name
    location                = azurerm_resource_group.lab-scorer.location
    ip_address_type         = "public"
    dns_name_label          = "lab-scorer"
    os_type                 = "Linux"

    container {
        name                = "lab-scorer-fe"
        image               = ""
        cpu                 = "1"
    }

    container {
        name                = "side-car"
        image               = ""
        cpu                 = ""
    }
}

azurerm_cosmosdb_account.lab-scorer.connection_strings.0