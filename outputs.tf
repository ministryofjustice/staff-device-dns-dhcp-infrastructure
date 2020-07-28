output "manifest" {
  value = "${data.template_file.manifest.rendered}"
}
