
# image_source 
# ------ Set Custom Images Id
locals {
    Okit_I_1667569695861_image_id = "ocid1.image.oc1.uk-london-1.aaaaaaaarx4rw4yy6njm74wxzd5dv4q6frbb2ru45lui3fc4j2vgp3fqyorq"
}

# ------ Create Instance
resource "oci_core_instance" "Okit_I_1667569695861" {
    # Required
    compartment_id      = local.DeploymentCompartment_id
    shape               = "VM.Standard.E2.1"
    # Optional
    display_name        = "orm-db1"
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains["1" - 1]["name"]
    create_vnic_details {
        # Required
        subnet_id        = local.Demo_Subnet_id
        # Optional
        assign_public_ip = true
        display_name     = "orm-db1 vnic"
        hostname_label   = "orm-db1"
        skip_source_dest_check = false
        freeform_tags    = {"OLCNE": "ormdbserver"}
    }
    metadata = {
        ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3CCbyxAz7vJ68BxNxw6njuMlxbqffKyziVR/+FfQL2opS6DvLugmE/9xHn93sQKKDJTwdrfE2pIAU63FX+bh8aSP9FqVNuXuwuG/xqoiIpBLCw5hVM0ownI+HwYt5eWrA55NpKKHLMCnZYXc3Lc//8gCw5ZEmX7+waN/EYiVO8AEj2L29HhTwnk1pVW4Rk1nWx4gczZo1vhFrKRGQq9UaUV3oF5DG/7nyelx3akSiQSnrOKgQVwmk1BQmSBuhFk6CFN/4DlzGWdtS8VcR9hCzjOO4iIiKBj/H8krA+eZZZr/RL2KHHc5UgYaq6kvpP31Cfrvkrq3kAF3zwviegi5/EM3qnjGxB5ZBKHpw2z567k91Tkyh3j8iW2clwviPtjXyvJLvCXy5UUW99egh152KOCG8vwMmrTdW7/D6f9BJ484dYqmJD3/9RvKvXpAXMHjQo8Q9h/INS9oYNWnEuEsr0+u3OaSTm4P2sd2bWtMRsFaHtTnPSD5en9auiSwPW4E= asaddiq@asaddiq-mac\n"
    }
    source_details {
        # Required
        source_id               = local.Okit_I_1667569695861_image_id
        source_type             = "image"
        # Optional
        boot_volume_size_in_gbs = "50"
#        kms_key_id              = 
    }
    preserve_boot_volume = false
    freeform_tags    = {"OLCNE": "ormdbserver"}
}

data "oci_core_private_ips" "Okit_I_1667569695861_private_ip" {
    #Optional
    ip_address = oci_core_instance.Okit_I_1667569695861.private_ip
    subnet_id = local.Demo_Subnet_id
}

locals {
    Okit_I_1667569695861_id               = oci_core_instance.Okit_I_1667569695861.id
    Okit_I_1667569695861_public_ip        = oci_core_instance.Okit_I_1667569695861.public_ip
    Okit_I_1667569695861_private_ip       = oci_core_instance.Okit_I_1667569695861.private_ip
    Okit_I_1667569695861_display_name     = oci_core_instance.Okit_I_1667569695861.display_name
    Okit_I_1667569695861_compartment_id   = oci_core_instance.Okit_I_1667569695861.compartment_id
    Okit_I_1667569695861_hostname         = "orm-db1"
    Okit_I_1667569695861_primary_vnic_id  = data.oci_core_private_ips.Okit_I_1667569695861_private_ip.private_ips[0].vnic_id
}

output "Okit_I_1667569695861PublicIP" {
    value = [local.Okit_I_1667569695861_display_name, local.Okit_I_1667569695861_public_ip]
}

output "Okit_I_1667569695861PrivateIP" {
    value = [local.Okit_I_1667569695861_display_name, local.Okit_I_1667569695861_private_ip]
}

# ------ Create Block Storage Attachments

# ------ Create VNic Attachments

