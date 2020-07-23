module "cognito" {
  source = "./modules/authentication"

   providers = {
    aws = aws.env
  }
}
