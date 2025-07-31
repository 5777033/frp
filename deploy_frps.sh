#!/bin/bash
# =========================================
# FRP 服务端一键安装脚本 (当前目录版)
# 适用于 Debian/Ubuntu 系统
# 作者: Jensen
# =========================================

set -e

# -----------------------------
# 使用当前目录
# -----------------------------
INSTALL_DIR=$(pwd)
TOKEN_DEFAULT="token_$(date +%s)"
DASHBOARD_PASS_DEFAULT="Admin@$(date +%Y)"

echo "====== FRP 服务端一键安装 ======"
read -p "请输入 FRP 认证 token (默认: $TOKEN_DEFAULT): " FRP_TOKEN
FRP_TOKEN=${FRP_TOKEN:-$TOKEN_DEFAULT}

read -p "请输入 Dashboard 登录密码 (默认: $DASHBOARD_PASS_DEFAULT): " DASHBOARD_PASS
DASHBOARD_PASS=${DASHBOARD_PASS:-$DASHBOARD_PASS_DEFAULT}

# -----------------------------
# 创建日志目录
# -----------------------------
mkdir -p "$INSTALL_DIR/logs"

# -----------------------------
# 生成 frps.toml
# -----------------------------
echo "[2/5] 创建配置文件 frps.toml"
cat > "$INSTALL_DIR/frps.toml" <<EOF
bindAddr = "0.0.0.0"
bindPort = 7000
kcpBindPort = 7001
quicBindPort = 7002

auth.method = "token"
auth.token = "$FRP_TOKEN"

webServer.addr = "0.0.0.0"
webServer.port = 7500
webServer.user = "admin"
webServer.password = "$DASHBOARD_PASS"

log.to = "/var/log/frp/frps.log"
log.level = "info"
log.maxDays = 7

maxPortsPerClient = 0
udpPacketSize = 1500

vhostHttpPort = 8080
vhostHttpsPort = 8443

transport.tcpMux = true
transport.tcpKeepalive = 7200
EOF

# -----------------------------
# 生成 compose.yml
# -----------------------------
echo "[3/5] 创建 Docker Compose 文件"
cat > "$INSTALL_DIR/compose.yml" <<EOF
version: '3.8'
services:
  frps:
    image: snowdreamtech/frps:latest
    container_name: frps
    restart: unless-stopped
    network_mode: host
    volumes:
      - ./frps.toml:/etc/frp/frps.toml:ro
      - ./logs:/var/log/frp
    environment:
      - TZ=Asia/Shanghai
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
EOF

# -----------------------------
# 启动服务
# -----------------------------
echo "[4/5] 启动 FRP 服务端..."
docker compose up -d

echo "========================================"
echo " ✅ FRP 服务端安装完成"
echo "----------------------------------------"
echo " 目录: $INSTALL_DIR"
echo " Token: $FRP_TOKEN"
echo " Dashboard: http://<服务器IP>:7500"
echo " 用户名：admin"
echo " 密码：$DASHBOARD_PASS"
echo "----------------------------------------"
echo " 查看运行状态: docker ps"
echo " 查看日志: docker logs -f frps"
echo " 停止服务: docker compose down"
echo "========================================"

