
# ------ Create Dhcp Options
# ------- Update VCN Default DHCP Option
resource "oci_core_default_dhcp_options" "DefaultDhcpOptionsForDemo_Vcn" {
    # Required
    manage_default_resource_id = local.Demo_Vcn_default_dhcp_options_id
    options    {
        type  = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
    }
    options    {
        type  = "SearchDomain"
        search_domain_names      = ["demo.oraclevcn.com"]
    }
    # Optional
    display_name   = "Default DHCP Options for demo-vcn"
}

locals {
    DefaultDhcpOptionsForDemo_Vcn_id = oci_core_default_dhcp_options.DefaultDhcpOptionsForDemo_Vcn.id
    }


# ------ Create Internet Gateway
resource "oci_core_internet_gateway" "Demo_Ig" {
    # Required
    compartment_id = local.DeploymentCompartment_id
    vcn_id         = local.Demo_Vcn_id
    # Optional
    enabled        = true
    display_name   = "demo-ig"
}

locals {
    Demo_Ig_id = oci_core_internet_gateway.Demo_Ig.id
}


# ------ Create Route Table
resource "oci_core_route_table" "Demo_Rt" {
    # Required
    compartment_id = local.DeploymentCompartment_id
    vcn_id         = local.Demo_Vcn_id
    route_rules    {
        destination_type  = "CIDR_BLOCK"
        destination       = "0.0.0.0/0"
        network_entity_id = local.Demo_Ig_id
    }
    # Optional
    display_name   = "demo-rt"
}

locals {
    Demo_Rt_id = oci_core_route_table.Demo_Rt.id
}


# ------ Create Security List
resource "oci_core_security_list" "Demo_Sec_List" {
    # Required
    compartment_id = local.DeploymentCompartment_id
    vcn_id         = local.Demo_Vcn_id
    egress_security_rules {
        # Required
        protocol    = "all"
        destination = "0.0.0.0/0"
        # Optional
        destination_type  = "CIDR_BLOCK"
    }
    ingress_security_rules {
        # Required
        protocol    = "6"
        source      = "10.0.0.0/28"
        # Optional
        source_type  = "CIDR_BLOCK"
        tcp_options {
            min = "3306"
            max = "3306"
        }
    }
    ingress_security_rules {
        # Required
        protocol    = "6"
        source      = "0.0.0.0/0"
        # Optional
        source_type  = "CIDR_BLOCK"
        tcp_options {
            min = "80"
            max = "80"
        }
    }
    ingress_security_rules {
        # Required
        protocol    = "6"
        source      = "0.0.0.0/0"
        # Optional
        source_type  = "CIDR_BLOCK"
        tcp_options {
            min = "20"
            max = "22"
        }
    }
    # ingress_security_rules {
    #     # Required
    #     protocol    = "6"
    #     source      = "0.0.0.0/0"
    #     # Optional
    #     source_type  = "CIDR_BLOCK"
    #     tcp_options {
    #         min = "200"
    #         max = "200"
    #     }
    # }

    # Optional
    display_name   = "demo-sec-list"
}

locals {
    Demo_Sec_List_id = oci_core_security_list.Demo_Sec_List.id
}


# ------ Create Subnet
# ---- Create Public Subnet
resource "oci_core_subnet" "Demo_Subnet" {
    # Required
    compartment_id             = local.DeploymentCompartment_id
    vcn_id                     = local.Demo_Vcn_id
    cidr_block                 = "10.0.0.0/28"
    # Optional
    display_name               = "demo-subnet"
    dns_label                  = "demosb"
    security_list_ids          = [local.Demo_Sec_List_id]
    route_table_id             = local.Demo_Rt_id
    dhcp_options_id            = local.DefaultDhcpOptionsForDemo_Vcn_id
    prohibit_public_ip_on_vnic = false
}

locals {
    Demo_Subnet_id              = oci_core_subnet.Demo_Subnet.id
    Demo_Subnet_domain_name     = oci_core_subnet.Demo_Subnet.subnet_domain_name
    Demo_Subnet_netmask         = substr(oci_core_subnet.Demo_Subnet.cidr_block, -2, -1)
}


# ------ Create Virtual Cloud Network
resource "oci_core_vcn" "Demo_Vcn" {
    # Required
    compartment_id = local.DeploymentCompartment_id
    cidr_block     = "10.0.0.0/24" 
    # Optional
    dns_label      = "demo"
    display_name   = "demo-vcn"
}

locals {
    Demo_Vcn_id                       = oci_core_vcn.Demo_Vcn.id
    Demo_Vcn_dhcp_options_id          = oci_core_vcn.Demo_Vcn.default_dhcp_options_id
    Demo_Vcn_domain_name              = oci_core_vcn.Demo_Vcn.vcn_domain_name
    Demo_Vcn_default_dhcp_options_id  = oci_core_vcn.Demo_Vcn.default_dhcp_options_id
    Demo_Vcn_default_security_list_id = oci_core_vcn.Demo_Vcn.default_security_list_id
    Demo_Vcn_default_route_table_id   = oci_core_vcn.Demo_Vcn.default_route_table_id
}

