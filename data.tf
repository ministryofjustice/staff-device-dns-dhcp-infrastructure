#-----------------------------------------------------------------
### Getting the staff-device-shared-services-infrastructure state
#-----------------------------------------------------------------
data "terraform_remote_state" "staff-device-shared-services-infrastructure" {
  backend = "s3"

  config = {
    bucket = "pttp-global-bootstrap-pttp-infrastructure-tf-remote-state"
    key    = "env:/ci/terraform/v1/state"
    region = "eu-west-2"
  }
}
