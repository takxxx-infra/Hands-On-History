# Python公式の軽量イメージ
FROM python:3.12-slim

# 作業ディレクトリの作成
WORKDIR /app

# 依存関係だけ先にコピーしてキャッシュを活用
COPY requirements.txt .

# 依存関係をインストール（キャッシュ利用、軽量化）
RUN pip install --no-cache-dir -r requirements.txt

# 残りのアプリケーションファイルをコピー
COPY . .

# Gunicornでアプリ起動
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:8000", "app:app"]