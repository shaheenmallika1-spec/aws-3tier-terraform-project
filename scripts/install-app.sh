#!/bin/bash
set -eu

APP_DIR="/opt/3tier-app"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

python3 -m venv venv
./venv/bin/pip install -r requirements.txt

chown -R ec2-user:ec2-user "$APP_DIR"

cat > /etc/systemd/system/3tier-flask.service <<'SERVICE'
[Unit]
Description=AWS 3-Tier Flask Application
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/3tier-app
EnvironmentFile=/opt/3tier-app/.env
ExecStart=/opt/3tier-app/venv/bin/python /opt/3tier-app/app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now 3tier-flask
