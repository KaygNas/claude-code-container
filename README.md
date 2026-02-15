# Claude Code Docker 容器

为 Claude Code 提供一个安全的 Docker 容器化运行环境。

## 环境要求

- Docker 20.10+
- Docker Compose v2

## 快速开始

### 1. 启动容器

使用默认 workspace（`./workspace`）：
```bash
./scripts/start.sh
```

指定自定义 workspace 路径：
```bash
./scripts/start.sh /path/to/your/workspace
```

### 2. 进入容器

```bash
./scripts/exec.sh
```

或直接使用 docker compose：
```bash
docker compose exec claude-code bash
```

### 3. 使用 Claude Code

在容器内直接使用：
```bash
claude --version
claude
```

### 4. 停止容器

```bash
./scripts/stop.sh
```

## 配置说明

### 环境变量 (.env)

| 变量 | 默认值 | 说明 |
|------|--------|------|
| UID | 1000 | 容器内用户 ID |
| GID | 1000 | 容器内组 ID |
| WORKSPACE_DIR | ./workspace | 工作目录路径 |

### 卷挂载

- **工作目录**: 挂载到容器的 `/workspace`
- **配置持久化**: Claude Code 配置存储在 Docker volume `claude-config` 中

## 安全特性

- 非 root 用户运行（UID/GID: 1000）
- 最小权限原则
- 网络隔离（bridge 模式）
- 配置文件持久化存储

## 常用命令

```bash
# 启动容器
docker compose up -d

# 查看日志
docker compose logs -f

# 进入容器
docker compose exec claude-code bash

# 停止容器
docker compose down

# 重建镜像
docker compose build --no-cache

# 清理所有资源
docker compose down -v
```

## 故障排查

### 容器无法启动

检查端口占用：
```bash
docker ps -a
```

查看日志：
```bash
docker compose logs
```

### 权限问题

确保 workspace 目录权限正确：
```bash
chmod -R 755 ./workspace
chown -R 1000:1000 ./workspace  # 如果需要
```

### 配置不生效

清理重建：
```bash
docker compose down -v
docker compose up -d
```
