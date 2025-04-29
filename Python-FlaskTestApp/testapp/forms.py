from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import Length, EqualTo, DataRequired, ValidationError
from testapp.models import User

class RegisterForm(FlaskForm):
    def validate_username(self, username_to_check):
        user = User.query.filter_by(username=username_to_check.data).first()
        if user:
            raise ValidationError("そのユーザー名はすでに使用されています。別のユーザー名を選択してください。")
    
    username = StringField(label="ユーザー名", validators=[DataRequired(), Length(min=4, max=20)])
    password = PasswordField(label="パスワード", validators=[DataRequired(), Length(min=6)])
    password2 = PasswordField(label="パスワード確認", validators=[EqualTo('password',
                                message="パスワードが一致しません。もう一度確認してください。"), DataRequired()])
    submit = SubmitField(label="登録")

class LoginForm(FlaskForm):
    username = StringField("ユーザー名", validators=[DataRequired()])
    password = PasswordField("パスワード", validators=[DataRequired()])
    submit = SubmitField("ログイン")

