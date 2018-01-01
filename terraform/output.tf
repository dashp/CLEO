 output "cleo-wordpress_user" { value = "ubuntu" }
 
 output "cleo-wordpress_host_ip" {
	 value = "${aws_instance.cleo-wordpress.public_ip}"
 }