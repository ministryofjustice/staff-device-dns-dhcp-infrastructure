resource "aws_cognito_user_pool" "pool" {
  name = "azure-ad-pool"
}

resource "aws_cognito_user_pool_client" "client" {
  name = "azure-ad-client"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "azure-ad-authentication"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}
