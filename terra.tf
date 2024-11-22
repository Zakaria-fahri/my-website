provider "oci" {
  tenancy_ocid        = "<your_tenancy_ocid>"
  user_ocid           = "<your_user_ocid>"
  fingerprint         = "<your_fingerprint>"
  private_key_path    = "<path_to_your_private_key>"
  region              = "<oci_region>"
}
resource "oci_core_virtual_network" "vcn" {
  cidr_block = "10.0.0.0/16"
  display_name = "my_vcn"
  compartment_id = "<your_compartment_ocid>"
}

resource "oci_core_subnet" "subnet" {
  cidr_block = "10.0.1.0/24"
  display_name = "my_subnet"
  vcn_id = oci_core_virtual_network.vcn.id
  compartment_id = "<your_compartment_ocid>"
  availability_domain = "<oci_availability_domain>"
}

resource "oci_core_instance" "instance" {
  compartment_id = "<your_compartment_ocid>"
  availability_domain = "<oci_availability_domain>"
  shape = "VM.Standard2.1"
  display_name = "my_instance"

  create_vnic_details {
    subnet_id = oci_core_subnet.subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = "<oci_image_ocid>"  # E.g., Ubuntu, Oracle Linux image OCID
  }

  metadata = {
    ssh_authorized_keys = "<your_public_ssh_key>"
  }

  # Optionally add more configuration, like tags, metadata, etc.
}

oxutput "instance_public_ip" {
  value = oci_core_instance.instance.public_ip
}
