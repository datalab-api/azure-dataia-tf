output "data_factory_name" {
  value = azurerm_data_factory.adf.name
}

output "pipeline_id" {
  value = azurerm_data_factory_pipeline.copy_pipeline.id
}
