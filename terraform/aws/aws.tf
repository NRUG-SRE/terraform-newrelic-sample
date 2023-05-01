module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = local.name
  cidr               = "10.0.0.0/16"
  azs                = ["${local.region}a", "${local.region}c"]
  public_subnets     = ["10.0.0.0/24", "10.0.1.0/24"]
  enable_nat_gateway = false
  enable_vpn_gateway = false
}

# ALB
resource "aws_security_group" "alb" {
  name   = "${local.name}-alb"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_ingress" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_alb" "web" {
  name               = local.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets[*]
}

resource "aws_alb_target_group" "web" {
  name        = local.name
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/bff/tracing-demo"
    protocol            = "HTTP"
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_alb_listener" "web" {
  load_balancer_arn = aws_alb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_alb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 4000
}

# EC2
resource "aws_security_group" "web" {
  name   = "${local.name}-web"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "web_ingress" {
  from_port                = 4000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web.id
  to_port                  = 4000
  type                     = "ingress"
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "web_egress_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

data "aws_ssm_parameter" "amazon_linux2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2"
}

data "aws_iam_policy" "ec2_role_for_ssm" {
  name = "AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "web" {
  name = local.name
  role = aws_iam_role.web.name
}

data "aws_iam_policy_document" "web" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "web" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.web.json

  managed_policy_arns = [
    data.aws_iam_policy.ec2_role_for_ssm.arn,
  ]
}

variable "new_relic_license_key" {}

resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.amazon_linux2_ami.value
  instance_type               = "t4g.micro"
  iam_instance_profile        = aws_iam_instance_profile.web.name
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    new_relic_license_key = var.new_relic_license_key
    application_name      = local.name
  }))

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

output "alb_dns_name" {
  value = aws_alb.web.dns_name
}
