data  "template_file" "user_data" {
    template = "${file("user-data/user_data.tpl")}"
    vars {
        region            = "${var.region}"
    }
}