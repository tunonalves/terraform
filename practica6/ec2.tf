resource "aws_instance" "public_instance" {
  ami                    = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key_ec2.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]


  provisioner "local-exec" {
    command = "echo instancia creada con IP $(aws_instance-public_instance-public.IP) >> datos_instancia.txt"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo instancia creada con IP $(aws_instance-public_instance-public.IP) Destruida >> datos_instancia.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hola Mundo' > ~/saludo.txt"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("C:/Users/tunon/Desktop/Terraform/mykey2.pem")
    }

  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      ami,
      instance_type,
      subnet_id,
      vpc_security_group_ids,
      key_name
    ]
  }
}
