# 🚀 RP 服务端 Docker compose 一键部署  

本项目用于快速部署 **FRP (Fast Reverse Proxy)** 服务端，支持 **TCP、UDP、HTTP、HTTPS、KCP、QUIC** 协议，采用 Docker Compose 一键启动。
FRP 功能描述:
FRP (Fast Reverse Proxy) 是一个高性能的反向代理应用，主要用于内网穿透。它允许你将外部的请求通过代理访问到内网服务器，突破了 NAT、防火墙等限制，特别适合远程访问内网服务、内网穿透、局域网访问等场景。

## FRP 主要功能：
内网穿透：使得外部设备可以访问内网服务器的服务，解决了 NAT（网络地址转换）和防火墙限制的问题。

反向代理：支持多种协议的反向代理，如 TCP、UDP、HTTP、HTTPS 等，允许远程访问局域网中的服务。

动态端口映射：支持动态创建端口映射，灵活配置访问规则。

Web 管理界面：提供 Web 控制面板，可以直观地查看连接状态、日志和管理各种配置。

加密和压缩：通过加密协议保证数据传输的安全性，支持数据压缩提高传输效率。

多协议支持：支持 TCP、UDP、HTTP、HTTPS、Socks5 等多种协议的转发。

客户端代理池：支持多个客户端同时连接，适用于大型分布式环境。

访问控制：通过令牌（Token）等手段实现对不同访问权限的控制。



---

## 📂 项目目录结构

* install\_frps.sh   一键安装脚本
* frps.toml         FRP 配置文件（脚本自动生成）
* compose.yml       Docker Compose 文件（脚本自动生成）
* logs/             日志文件目录（脚本自动创建）

---

## 🛠️ 安装步骤

### 1️⃣ 上传脚本至服务器

将 `deploy_frps.sh` 上传至目标服务器的任意目录，例如 `/data/frp`。

```
wget https://raw.githubusercontent.com/5777033/frp/main/deploy_frps.sh
```

### 2️⃣ 赋予执行权限

```
chmod +x deploy_frps.sh
```

---

### 3️⃣ 运行安装脚本

```
./install_frps.sh
```

脚本将自动执行以下操作：

* 安装 Docker 和 Docker Compose
* 生成 frps.toml 配置文件
* 生成 compose.yml
* 启动 FRP 服务端容器

运行过程中会要求输入：

* FRP Token（用于客户端认证）
* Dashboard 密码（用于管理面板登录）
  （直接回车可使用自动生成的默认值）

---

### 4️⃣ 端口说明

| 功能           | 端口   |
| ------------ | ---- |
| FRP 服务监听     | 7000 |
| KCP          | 7001 |
| QUIC         | 7002 |
| HTTP 虚拟主机    | 8080 |
| HTTPS 虚拟主机   | 8443 |
| Dashboard 面板 | 7500 |

> 请确保服务器防火墙已放行以上端口。

---

### 5️⃣ 查看运行状态

```
docker ps
```

查看实时日志：

```
docker logs -f frps
```

停止 FRP 服务：

```
docker compose down
```

重启 FRP 服务：

```
docker compose restart
```

---

### 6️⃣ 访问 Dashboard

浏览器访问：

```
http://服务器IP:7500
```

* 用户名：admin
* 密码：安装时输入或默认自动生成

---

### 7️⃣ 客户端配置示例

创建 `frpc.ini`：

```
[common]
server_addr = <服务器IP>
server_port = 7000
auth_token = <你的token>

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```

启动客户端：

```
frpc -c frpc.ini
```

---

## 🔐 安全建议

* 修改 Token 和 Dashboard 密码为更复杂的随机字符串
* 通过防火墙或安全组限制访问 Dashboard 面板
* 生产环境建议启用 TLS 加密通信

---

这样写的 `README.md` 在 **GitHub、Gitea、VSCode、Typora** 等 Markdown 解析器中都会正常显示。





---
# FRP 服务端 Docker compose 一键部署 请转至FRPC_README.md
