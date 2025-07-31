# 🚀 FRP 客户端 Docker 部署说明

本项目提供 **FRP 客户端一键部署脚本 (`deploy_frpc.sh`)**，通过 Docker 快速连接到 FRP 服务端，实现内网穿透功能。

---

## 📌 前提条件

* **已安装** Docker 和 Docker Compose

* **已知 FRP 服务端公网 IP 和正确的 Token**
  
  > ⚠️ 请先在服务器执行以下命令查看 Token：
  > 
  > ```
  > cat /data/frp/frps.toml | grep token
  > ```
  > 
  > 客户端必须使用与服务端一致的 `auth.token`，否则无法连接。

---

## 📦 一键部署命令

直接下载并执行脚本：

```
wget https://raw.githubusercontent.com/5777033/frp/main/deploy_frpc.sh
chmod +x deploy_frpc.sh
./deploy_frpc.sh
```

脚本会自动完成以下操作：

* 根据输入信息生成 `frpc.toml` 配置文件
* 生成 `compose.yml` Docker Compose 文件
* 启动 FRP 客户端容器

---

## ⚙️ 常用命令

查看客户端运行状态：

```
docker ps
```

查看运行日志：

```
docker logs -f frpc
```

停止客户端：

```
docker compose down
```

重启客户端：

```
docker compose restart
```

---

## 🔐 安全建议

* 确保 Token 足够复杂，避免被盗用
* 防火墙仅开放必要端口
* 建议使用 TLS 加密保护通信



