#!/bin/bash
set -e

# データベースマイグレーションの実行
flask db upgrade

# アプリケーションの起動
exec gunicorn -w 1 --bind 0.0.0.0:8000 "app:app"