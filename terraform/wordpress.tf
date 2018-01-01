provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}
resource "aws_security_group" "cleo-wordpress-sg" {
  name        = "${var.name}"
  description = "Cleo Wordpress security group"
  tags { Name = "${var.name}" }

}

resource "aws_security_group_rule" "allow_ssh_traffic_from_ip_range" {
    type  = "ingress"
    from_port   =  22
    to_port     =  22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.cleo-wordpress-sg.id}"
}
resource "aws_security_group_rule" "allow_http_traffic_from_ip_range" {
    type  = "ingress"
    from_port   =  80
    to_port     =  80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.cleo-wordpress-sg.id}"
}
resource "aws_security_group_rule" "send_out_bound_traffic_to_world" {
    type  = "egress"
    from_port   =  0
    to_port     =  0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.cleo-wordpress-sg.id}"
}

resource "aws_instance" "cleo-wordpress" {
  ami                    = "${var.ami}"
  instance_type          = "${var.wordpress_instance_type}"
  vpc_security_group_ids = ["${aws_security_group.cleo-wordpress-sg.id}"]
  key_name               = "${var.key_name}"
  tags { Name = "${var.name}" }
  user_data              = "${data.template_file.user_data.rendered}"
}