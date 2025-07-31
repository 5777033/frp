#!/bin/bash
# =========================================
# FRP 客户端一键部署脚本 (Docker版)
# 不安装 Docker/Docker Compose，需预先安装
# 作者: Jensen
# =========================================

set -e

INSTALL_DIR=$(pwd)

echo "====== FRP 客户端部署脚本 ======"

read -p "请输入 FRPS 服务器IP地址: " SERVER_IP
read -p "请输入 FRPS 服务器端口 (默认7000): " SERVER_PORT
SERVER_PORT=${SERVER_PORT:-7000}

read -p "请输入认证Token: " FRP_TOKEN

read -p "是否配置SSH转发 (y/n, 默认y): " SSH_FORWARD
SSH_FORWARD=${SSH_FORWARD:-y}

if [ "$SSH_FORWARD" == "y" ]; then
    read -p "请输入本机SSH端口 (默认22): " LOCAL_SSH_PORT
    LOCAL_SSH_PORT=${LOCAL_SSH_PORT:-22}
    read -p "请输入远程暴露端口 (默认6000): " REMOTE_SSH_PORT
    REMOTE_SSH_PORT=${REMOTE_SSH_PORT:-6000}
fi

# 创建日志目录
mkdir -p "$INSTALL_DIR/logs"

# 生成 frpc.toml
echo "[1/3] 创建配置文件 frpc.toml..."
cat > "$INSTALL_DIR/frpc.toml" <<EOF
serverAddr = "$SERVER_IP"
serverPort = $SERVER_PORT
auth.token = "$FRP_TOKEN"
EOF

if [ "$SSH_FORWARD" == "y" ]; then
cat >> "$INSTALL_DIR/frpc.toml" <<EOF

[[proxies]]
name = "ssh"
type = "tcp"
localIP = "127.0.0.1"
localPort = $LOCAL_SSH_PORT
remotePort = $REMOTE_SSH_PORT
EOF
fi

# 生成 compose.yml
echo "[2/3] 创建 Docker Compose 文件..."
cat > "$INSTALL_DIR/compose.yml" <<EOF
version: '3.8'
services:
  frpc:
    image: snowdreamtech/frpc:latest
    container_name: frpc
    restart: unless-stopped
    network_mode: host
    volumes:
      - ./frpc.toml:/etc/frp/frpc.toml
    environment:
      - TZ=Asia/Shanghai
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
EOF

# 启动 FRP 客户端
echo "[3/3] 启动 FRP 客户端容器..."
docker compose up -d

echo "========================================"
echo " ✅ FRP 客户端部署完成"
echo "----------------------------------------"
echo " 目录: $INSTALL_DIR"
echo " 服务器地址: $SERVER_IP:$SERVER_PORT"
echo " Token: $FRP_TOKEN"
if [ "$SSH_FORWARD" == "y" ]; then
    echo " SSH 映射: ssh -p $REMOTE_SSH_PORT <用户名>@$SERVER_IP"
fi
echo "----------------------------------------"
echo " 查看状态: docker ps"
echo " 查看日志: docker logs -f frpc"
echo " 停止服务: docker compose down"
echo "========================================"

