#!/bin/sh
set -eu
: "${UUID:?UUID env var is required}"
: "${WS_PATH:?WS_PATH env var is required}"
PORT="${PORT:-10000}"
mkdir -p /etc/sing-box
cat > /etc/sing-box/config.json <<EOF
{
  "log": {"level": "info", "timestamp": true},
  "inbounds": [
    {
      "type": "vless",
      "tag": "vless-in",
      "listen": "0.0.0.0",
      "listen_port": ${PORT},
      "users": [{"uuid": "${UUID}"}],
      "transport": {"type": "ws", "path": "${WS_PATH}"}
    }
  ],
  "outbounds": [{"type": "direct", "tag": "direct"}]
}
EOF
echo "Starting sing-box on 0.0.0.0:${PORT} path ${WS_PATH}"
exec sing-box run -c /etc/sing-box/config.json
