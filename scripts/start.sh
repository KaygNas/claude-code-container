#!/bin/bash

CONTAINER_NAME="claude-code-container"
WORKSPACE="${1:-./workspace}"

# 解析参数
RECREATE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--recreate)
            RECREATE=true
            shift
            ;;
        *)
            WORKSPACE="$1"
            shift
            ;;
    esac
done

# 创建 workspace 目录（如果不存在）
mkdir -p "$WORKSPACE"
WORKSPACE_DIR="$(cd "$WORKSPACE" && pwd)"

# 检查容器是否在运行
if docker ps --filter "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "容器 $CONTAINER_NAME 已在运行中"
    echo "Workspace: $WORKSPACE_DIR"
    echo "正在进入容器..."
    docker compose exec claude-code bash
    exit $?
fi

# 检查容器是否已创建但未运行
if docker ps -a --filter "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    if [ "$RECREATE" = true ]; then
        echo "容器已存在，正在重新创建..."
        WORKSPACE_DIR="$WORKSPACE_DIR" docker compose up -d --force-recreate
    else
        echo "容器已创建但未运行，正在启动..."
        WORKSPACE_DIR="$WORKSPACE_DIR" docker compose up -d
    fi
else
    # 容器不存在，需要构建并启动
    echo "容器不存在，正在构建并启动..."
    WORKSPACE_DIR="$WORKSPACE_DIR" docker compose up -d --build
fi

echo ""
echo "Claude Code 容器已启动"
echo "Workspace: $WORKSPACE_DIR"
echo "正在进入容器..."
docker compose exec claude-code bash
