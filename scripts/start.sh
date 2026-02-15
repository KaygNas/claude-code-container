#!/bin/bash

# 设置默认 workspace 目录
WORKSPACE="${1:-./workspace}"

# 创建 workspace 目录（如果不存在）
mkdir -p "$WORKSPACE"

# 设置环境变量并启动容器
WORKSPACE_DIR="$(cd "$WORKSPACE" && pwd)" docker compose up -d

echo "Claude Code 容器已启动"
echo "Workspace: $WORKSPACE"
echo "使用以下命令进入容器:"
echo "  ./scripts/exec.sh"
echo "或使用 docker compose:"
echo "  docker compose exec claude-code bash"
