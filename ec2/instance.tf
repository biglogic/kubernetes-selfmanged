
resource "aws_instance" "instance" {
    for_each = var.aws_instance
    ami           = var.pub_ami
    associate_public_ip_address =  "true"
    instance_type = each.value.instance_type
    key_name = var.instancekey_name
    subnet_id = var.subpubid
    root_block_device {
        volume_size = 30 # in GB <<----- I increased this!
        volume_type = "gp3"
  }
    vpc_security_group_ids = [ var.sg_id ]
    tags = {
        Name = each.key
    }
    
    provisioner "file" {
    source      = "/tmp/common.sh"  # Path to your local common.sh
    destination = "/tmp/common.sh"            # Remote destination path

    connection {
      type        = "ssh"
      user        = "ubuntu"                # Use the correct user for your AMI
      private_key = file("~/Downloads/project.pem")
      host        = self.public_ip
    }
    }
  
    # Step 2: Copy master.sh to the instance, but only for master-node
    provisioner "file" {
    source      = "/tmp/master.sh"   # Path to your local master.sh
    destination = "/tmp/master.sh"            # Remote destination path

    connection {
      type        = "ssh"
      user        = "ubuntu"                # Use the correct user for your AMI
      private_key = file("~/Downloads/project.pem")
      host        = self.public_ip
    }  

    # Only execute this provisioner for the master node
    
    }
    
    # Step 3: Execute common.sh on the instance
    provisioner "remote-exec" {
    when = create
    inline = [
      "chmod +x /tmp/common.sh",
      "bash /tmp/common.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/Downloads/project.pem")
      host        = self.public_ip
    }
    }

    provisioner "remote-exec" {
    when = create
    inline = [
      "if [ \"${each.key}\" == \"master-node\" ]; then chmod +x /tmp/master.sh; bash /tmp/master.sh; fi"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/Downloads/project.pem")
      host        = self.public_ip
    }
  }


}
  



