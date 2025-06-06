# Создание IAM роли для EC2 инстансов
resource "aws_iam_role" "ssm_role" {
  name = "EC2SSMInstanceProfileRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Присоединение управляемой политики SSM к роли
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # Управляемая политика AWS для SSM
}

# Присоединение политики ECR к роли
resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# Создание профиля инстанса для роли
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "EC2SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
} 