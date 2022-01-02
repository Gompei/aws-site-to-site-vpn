resource "aws_security_group" "icmp" {
  vpc_id = aws_vpc.vpc.id
  name   = "example-icmp-sg"

  ingress {
    from_port   = -1
    protocol    = "ICMP"
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "icmp"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
