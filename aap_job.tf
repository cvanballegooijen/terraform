data "aap_job_template" "deploy_web_server" {
  name              = "Deploy Web Server"
  organization_name = var.organization_name
}

data "aap_job_template" "deploy_web_site" {
  name              = "Deploy Web Site"
  organization_name = var.organization_name
}


resource "aap_job" "deploy_web_server" {
  inventory_id = aap_inventory.inventory.id
  job_template_id = data.aap_job_template.deploy_web_server.id
  wait_for_completion                 = true
  wait_for_completion_timeout_seconds = 180
  triggers = {
    "aap_job_run_timestamp":timestamp()
  }
  depends_on = [
    aap_host.my_host,
    aap_group.my_group
  ]
}

resource "aap_job" "deploy_web_site" {
  inventory_id = aap_inventory.inventory.id
  job_template_id = data.aap_job_template.deploy_web_site.id
  wait_for_completion                 = true
  wait_for_completion_timeout_seconds = 180

  triggers = {
    "aap_job_run_timestamp":timestamp()
  }

  depends_on = [
    aap_job.webserver
  ]
}

