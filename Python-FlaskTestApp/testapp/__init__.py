import os
from flask import Flask
from flask_migrate import Migrate # type: ignore
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from dotenv import load_dotenv

FLASK_ENV = os.getenv('FLASK_ENV', 'development')
# ローカル開発環境の場合のみ.envを読み込む
if FLASK_ENV == 'development':
    load_dotenv()

app = Flask(__name__)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "secretkey")

if FLASK_ENV == 'production':
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = os.getenv('DB_PASSWORD')
    DB_HOST = os.getenv('DB_HOST')
    DB_NAME = os.getenv('DB_NAME')
    app.config["SQLALCHEMY_DATABASE_URI"] = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
else:
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv('DATABASE_URL')


app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy()
db.init_app(app)
migrate = Migrate(app, db)

bcrypt = Bcrypt(app)

login_manager = LoginManager()
login_manager.login_view = "login"
login_manager.login_message = "ログインしてください。"
login_manager.init_app(app)

from testapp import routes