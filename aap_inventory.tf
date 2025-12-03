data "aap_job_template" "deploy_web_server" {
  name              = "Deploy Web Server"
  organization_name = var.organization_name
}

data "aap_job_template" "deploy_web_site" {
  name              = "Deploy Web Site"
  organization_name = var.organization_name
}


resource "aap_inventory" "inventory" {
  name         = "${var.instance_name_prefix}-aap-inventory"
  description  = "A new inventory"
  organization = 2
}

# Add the new EC2 instance to the inventory
resource "aap_host" "my_host" {
  for_each     = { for idx, instance in aws_instance.web_server : idx => instance }
  inventory_id = aap_inventory.inventory.id
  groups = toset([resource.aap_group.my_group.id])
  name         = each.value.tags.Name
  description  = "Host provisioned by HCP Terraform"
  variables    = jsonencode({
    ansible_user = "ec2-user"
    ansible_host = each.value.public_ip
    #public_ip    = each.value.public_ip
    #target_hosts = each.value.public_ip
  })
}

# Create some infrastructure - inventory group - that has an action tied to it
resource "aap_group" "my_group" {
  name = "role_webserver"
  inventory_id = aap_inventory.inventory.id
}



