resource "aws_instance" "public_instance" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name = aws_key_pair.project_key_pair.key_name
  tags = {
    Name = "PublicInstance"
  }
}

resource "aws_instance" "private_instance" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name = aws_key_pair.project_key_pair.key_name
  tags = {
    Name = "PrivateInstance"
  }
}