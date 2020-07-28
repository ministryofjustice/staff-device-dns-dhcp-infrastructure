resource "aws_eip" "lb" {
  network_interface = "${aws_instance.web.id}"
  vpc               = true
}
