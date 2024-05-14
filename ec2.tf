resource "aws_instance" "db" {

  ami = "ami-090252cbe067a9e58"
  vpc_security_group_ids = [ "sg-0b4982a41aa37eaa1" ]
  instance_type = "t2.micro"

#provisioners will only run when you are creating resources 
#they won't run once the resuorces are already created 
provisioner "local-exec" {
    command = "echo ${self.private_ip} > private_ips.txt"
  }

provisioner "local-exec" {
    command = "ansible-playbook -i private_ips.txt web.yaml"
  }

    # provisioner "local-exec" {
    #     command = "ansible-playbook -i private_ips.txt web.yaml"
    # }

connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = self.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "sudo dnf install ansible -y",
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx"
    ]
  } 
}

}