variable "default_location" {
  description = "Default location for all Azure resources"
  default     = "West Europe"
}

variable "location_infix" {
  description = "Default infix for resources. Used in a naming convention {resource_type}-{service-name}-{LOCATION_INFIX}-{env_sufix}"
  default     = "we"
}

variable "env_suffix" {
  description   = "Default sufix for resources. Used in a naming convention {resource_type}-{service-name}-{location_infix}-{ENV_SUFFIX}"
  default       = "test"
}

variable "storage_account_env_suffix" {
  description   = "Default sufix for naming storage account in an environment. Can contain only lowercase letters"
  default       = "test"
}

variable "pr_number" {
  description   = "Unique number for the Pull Request"
  default       = "1"
}

variable "sql_username" {
  description = "Username for the SQL Server"
  default     = "pradmin"
}