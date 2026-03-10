#!/bin/bash

docker run \
  --rm \
  --name claw \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e LC_ALL=zh_CN.UTF-8 \
  -e MOONSHOT_API_KEY=abc \
  -e OPENCLAW_PRIMARY_MODEL=moonshot/kimi-k2.5 \
  -e OPENCLAW_GATEWAY_TOKEN=abcd \
  -e OPENCLAW_WORKSPACE_DIR=/config/.openclaw/workspace \
  -e OPENCLAW_STATE_DIR=/config/.openclaw \
  -e HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew \
  -e HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar \
  -e HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew \
  -p 3000:3000 \
  -p 3001:3001 \
  --shm-size="1gb" \
  registry.cn-beijing.aliyuncs.com/zexi/openclaw:ubu-20260310.7
  # registry.cn-beijing.aliyuncs.com/zexi/openclaw:ubu-20260228.2
