data "aws_ssm_parameter" "amazon_linux_2022_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2022-ami-kernel-5.10-x86_64"
}

resource "aws_network_interface" "network_interface" {
  subnet_id = aws_subnet.private[0].id
  security_groups = [
    aws_security_group.icmp.id,
    aws_vpc.vpc.default_security_group_id
  ]
}

resource "aws_instance" "instance" {
  ami           = data.aws_ssm_parameter.amazon_linux_2022_ami.value
  instance_type = "t3.micro"
  tenancy       = "default"

  ebs_block_device {
    device_name           = "/dev/sda1"
    delete_on_termination = true
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.network_interface.id
  }
}
