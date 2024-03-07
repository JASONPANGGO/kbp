#!/bin/bash

# 检查是否有输入端口号
if [ -z "$1" ]; then
  echo "Usage: $0 <port-number>"
  exit 1
fi

# 检查当前用户是否为root，因为一些端口可能需要超级用户权限来杀进程
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

# 保存端口号
PORT=$1

# 使用lsof命令找到监听在输入端口上的所有进程PID
PIDS=$(lsof -i tcp:${PORT} -t 2>/dev/null)

# 检查是否有找到PID
if [ -z "$PIDS" ]; then
  echo "No process is listening on port $PORT"
  exit 1
fi

# 杀掉进程
echo "Killing the following process(es) listening on port $PORT:"
echo "$PIDS"
for PID in $PIDS; do
  kill -9 $PID 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Process $PID has been killed."
  else
    echo "Failed to kill process $PID"
  fi
done

echo "All processes listening on port $PORT have been killed."
