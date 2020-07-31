locals {
  critical_notifications_count = var.enable_critical_notifications ? 1 : 0
}

resource "aws_sns_topic" "this" {
  name = "${var.prefix}-${var.topic_name}"
}

data "template_file" "email_subscription" {
  count = "${length(var.emails)}"
  vars = {
    email     = "${element(var.emails, count.index)}"
    index     = "${count.index}"
    topic_arn = "${aws_sns_topic.this.arn}"

    # Name must be alphanumeric, unique, but also consistent based on the email address.
    # It also needs to stay under 255 characters.
    name = "${sha256("${var.topic-name}-${element(var.emails, count.index)}")}"
  }

  template = <<-STACK
  $${jsonencode(name)}: {
    "Type" : "AWS::SNS::Subscription",
    "Properties": {
      "Endpoint": $${jsonencode(email)},
      "Protocol": "email",
      "TopicArn": $${jsonencode(topic_arn)}
    }
  }
  STACK
}

resource "aws_cloudformation_stack" "email" {
  count = local.critical_notifications_count
  name  = "${var.prefix}-${var.topic-name}-subscriptions"

  template_body = <<-STACK
  {
    "Resources": {
      ${join(",", sort(data.template_file.email_subscription.*.rendered))}
    }
  }
  STACK
}
