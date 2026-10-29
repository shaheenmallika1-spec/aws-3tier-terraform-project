
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-03d4917d1aa9c7157"
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name

  associate_public_ip_address = false


  user_data = <<-EOF
    #!/bin/bash
    set -eux

    exec > /var/log/3tier-user-data.log 2>&1

    mkdir -p /var/www/html

    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
      <head><title>AWS 3-Tier Project</title></head>
      <body>
        <h1>AWS 3-Tier Architecture</h1>
        <p>Application EC2 instance is running!</p>
      </body>
    </html>
    HTML

    if ! command -v python3 >/dev/null 2>&1; then
      echo "ERROR: python3 is not installed"
      exit 1
    fi

    cat > /etc/systemd/system/3tier-app.service <<'SERVICE'
    [Unit]
    Description=AWS 3-Tier Python Web Application
    After=network.target

    [Service]
    Type=simple
    WorkingDirectory=/var/www/html
    ExecStart=/usr/bin/python3 -m http.server 80 --directory /var/www/html
    Restart=always
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now 3tier-app.service
    curl -f http://127.0.0.1/ || exit 1
  EOF


  tags = {
    Name        = "${var.project_name}-${var.environment}-app-ec2"
    Environment = var.environment
    Project     = var.project_name
    Tier        = "app"
  }
}


resource "aws_iam_role" "ssm" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-profile"
  role = aws_iam_role.ssm.name
}