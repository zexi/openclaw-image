#!/usr/bin/env bash
set -euo pipefail

# 调试日志：autostart 时 stdout 可能不可见，同时写入固定文件便于 docker exec 查看
LOG_FILE="${OPENCLAW_OPEN_BROWSER_LOG:-/tmp/openclaw-open-browser.log}"
log() { echo "[$(date -Iseconds)] [openclaw-open-browser] $*" | tee -a "$LOG_FILE" >&2; }

log "script started (PID=$$, USER=$(whoami), DISPLAY=${DISPLAY:-<unset>})"

URL="http://localhost:18789/?token=${OPENCLAW_GATEWAY_TOKEN:-}"

# 如果没 token，就没必要打开浏览器
if [ -z "${OPENCLAW_GATEWAY_TOKEN:-}" ]; then
  log "OPENCLAW_GATEWAY_TOKEN not set, skip"
  exit 0
fi

log "waiting for openclaw gateway health (up to ~2 min)..."

# 等 openclaw 网关变健康（最多等待约 2 分钟）
GATEWAY_OK=0
for i in $(seq 1 120); do
  if curl -fsS "http://localhost:18789/healthz?token=${OPENCLAW_GATEWAY_TOKEN}" >/dev/null 2>&1; then
    log "gateway healthy after ${i}s"
    GATEWAY_OK=1
    break
  fi
  sleep 1
done
[ "$GATEWAY_OK" -eq 0 ] && log "WARNING: gateway health check timed out after 120s"

# 选择浏览器（优先 chromium）
if command -v chromium >/dev/null 2>&1; then
  BROWSER="chromium"
elif command -v chromium-browser >/dev/null 2>&1; then
  BROWSER="chromium-browser"
elif command -v firefox >/dev/null 2>&1; then
  BROWSER="firefox"
else
  BROWSER="xdg-open"
fi

log "using browser: ${BROWSER}"
log "chown /config/.openclaw to 1000:1000..."
chown -R 1000:1000 /config/.openclaw 2>&1 | tee -a "$LOG_FILE" || log "chown failed (non-fatal): $?"

log "launching: ${BROWSER} ${URL}"

# 对 chromium 系列启用最大化窗口和 no-sandbox，其他浏览器用默认参数
case "${BROWSER}" in
  chromium|chromium-browser)
    nohup "${BROWSER}" --no-sandbox --start-maximized "${URL}" >>"$LOG_FILE" 2>&1 &
    ;;
  *)
    nohup "${BROWSER}" "${URL}" >>"$LOG_FILE" 2>&1 &
    ;;
esac
BGPID=$!
log "browser started in background (PID=$BGPID)"

