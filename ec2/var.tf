variable "pub_ami" {
  type = string
}

variable "aws_instance" {
      type = map(object({
       instance_type = string
      }))
      default = {
      "master-node" = {
            instance_type = "t3.medium"
      }  
      "worker-node-1" = {
            instance_type = "t2.medium"
      }
      "worker-node-2" = {
            instance_type = "t2.medium"
      }
      }
}


variable "instancekey_name" {
      type = string
      default = "project"
}

variable "subpubid" {
     type = string
     
}

variable "sg_id" {
      type = string
}
