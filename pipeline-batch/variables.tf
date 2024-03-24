variable "resource_group_name" {
  type = string
}

variable "adf_location" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

# Linked service details (replace with your service type)
variable "linked_service_name" {
  type = string
}

variable "linked_service_connection_string" {
  type      = string
  sensitive = true
}

# Pipeline details
variable "pipeline_name" {
  type = string
}

variable "source_dataset_name" {
  type = string
}

variable "sink_dataset_name" {
  type = string
}
