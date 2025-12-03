action "aap_eda_eventstream_post" "create" {
  config {
    limit = "role_webserver"
    ## job_workflow
    template_type = "workflow_job"
    workflow_job_template_name = "Deploy Web App"
    organization_name = "TechXchangeNL"

    event_stream_config = {
      url = var.aap_eventstream_url
      insecure_skip_verify = true
      username = "aap"
      password = "aap"
    }
  }
}
