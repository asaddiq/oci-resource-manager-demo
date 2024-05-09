# This code is auto generated and any changes will be lost if it is regenerated.

# -- Copyright: Copyright (c) 2020, 2022, Oracle and/or its affiliates.
# ---- Author : Andrew Hopkinson (Oracle Cloud Solutions A-Team)


# ------ Connect to Provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# ------ Home Region Provider
locals {
    home_region =  var.region
}
 
provider "oci" {
    alias            = "home_region"
    tenancy_ocid     = var.tenancy_ocid
    user_ocid        = var.user_ocid
    fingerprint      = var.fingerprint
    private_key_path = var.private_key_path
    region           = local.home_region
}

output "Home_Region_Name" {
 value = local.home_region
}
