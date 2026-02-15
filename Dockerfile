FROM node:20-slim

# 安装必要的系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 创建非 root 用户
RUN groupadd -g 1001 claude && \
    useradd -u 1001 -g claude -m -s /bin/bash claude

# 安装 Claude Code CLI（以 root 安装，所有用户可用）
RUN npm install -g @anthropic-ai/claude-code

# 设置工作目录
WORKDIR /workspace

# 切换到非 root 用户
USER claude

# 默认命令
CMD ["bash"]
