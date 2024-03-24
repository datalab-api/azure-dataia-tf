
# Create the Data Factory
resource "azurerm_data_factory" "adf" {
  name                = "my-data-factory"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Linked Service (replace with your specific type)
resource "azurerm_data_factory_linked_service" "storage_linked_service" {
  name              = var.linked_service_name
  data_factory_id   = azurerm_data_factory.adf.id
  connection_string = var.linked_service_connection_string
  # ... Other linked service configurations based on type
}

# Dataset (Azure Blob Storage Example)
resource "azurerm_data_factory_dataset" "source_dataset" {
  name                = var.source_dataset_name
  data_factory_id     = azurerm_data_factory.adf.id
  folder_path         = format("abfs://%s@%s.dfs.core.windows.net/container", var.storage_account_name, var.storage_account_name)
  type                = "Blobstore"
  linked_service_name = azurerm_data_factory_linked_service.storage_linked_service.name
  # ... Other dataset configurations based on format
}

# Dataset (Sink can be similar to source with different details)
resource "azurerm_data_factory_dataset" "sink_dataset" {
  name            = var.sink_dataset_name
  data_factory_id = azurerm_data_factory.adf.id
  # ... Define details for your sink dataset
}

# Pipeline with copy activity
resource "azurerm_data_factory_pipeline" "copy_pipeline" {
  name            = var.pipeline_name
  data_factory_id = azurerm_data_factory.adf.id
  is_active       = true

  activity {
    name = "Copy Data"
    type = "Copy"
    inputs = {
      source = azurerm_data_factory_dataset.source_dataset.name
    }
    outputs = {
      sink = azurerm_data_factory_dataset.sink_dataset.name
    }
    # ... Other activity configurations
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_data_factory" "pipemine" {
  name                = var.datafactory_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.sku_name

  tags = {
    environment = "Production"
  }
}

resource "azurerm_data_factory_pipeline" "example_pipeline" {
  name                = "ExamplePipeline"
  data_factory_name   = azurerm_data_factory.pipemine.name
  resource_group_name = azurerm_resource_group.rg.name

  activities {
    name = "KafkaToBlobActivity"

    type = "Copy"

    type_properties {
      source {
        type           = "KafkaSource"
        consumer_group = "myConsumerGroup"
        topic          = "myKafkaTopic"
      }

      sink {
        type = "BlobSink"
      }
    }

    inputs {
      reference_name = "KafkaInputDataset"
    }

    outputs {
      reference_name = "OutputDataset"
    }
  }
}

resource "azurerm_data_factory_dataset_kafka" "kafka_input_dataset" {
  name                = "KafkaInputDataset"
  data_factory_name   = azurerm_data_factory.pipemine.name
  resource_group_name = azurerm_resource_group.rg.name

  properties {
    event_hub_name        = "event_hub_name"
    service_bus_namespace = "service_bus_namespace"
    consumer_group        = "myConsumerGroup"
  }
}

resource "azurerm_data_factory_dataset_blob" "output_dataset" {
  name                = "OutputDataset"
  data_factory_name   = azurerm_data_factory.pipemine.name
  resource_group_name = azurerm_resource_group.rg.name

  linked_service_name = azurerm_data_factory_linked_service_blob_storage.example.name

  folder_path = "output/"
  file_path   = "output_data.csv"

  format {
    type = "TextFormat"
  }
}

resource "azurerm_data_factory_linked_service_blob_storage" "example" {
  name                = "ExampleBlobStorage"
  data_factory_name   = azurerm_data_factory.pipemine.name
  resource_group_name = azurerm_resource_group.rg.name

  properties {
    account_name   = "storage_account_name"
    container_name = "container_name"
    linked_service_key {
      type           = "AzureKeyVaultSecret"
      secret_name    = "storage_secret_name"
      secret_version = "storage_secret_version"
    }
  }
}
