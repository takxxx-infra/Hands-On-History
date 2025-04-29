from testapp import app, db
from flask import render_template, redirect, url_for, flash
from flask_login import login_user, login_required, logout_user
from testapp.forms import RegisterForm, LoginForm
from testapp.models import User

@app.route("/register", methods=["GET", "POST"])
def register():
    form = RegisterForm()
    if form.validate_on_submit():
        user_to_create = User(username=form.username.data,password=form.password.data)
        db.session.add(user_to_create)
        db.session.commit()
        flash("ユーザ登録に成功しました。ログインしてください。", category='success')
        return redirect(url_for("login"))
    if form.errors != {}:
        flash(f"ユーザー登録中にエラーが発生しています", category='danger')
    return render_template("register.html", form=form)

@app.route("/login", methods=["GET", "POST"])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        attempted_user = User.query.filter_by(username=form.username.data).first()
        if attempted_user and attempted_user.check_password_correction(
            attempted_password=form.password.data
        ):
            login_user(attempted_user)
            flash("ログイン成功しました。" , category='success')
            return redirect(url_for("index"))
        else:
            flash("ユーザー名またはパスワードが間違っています。" , category='danger')
    return render_template("login.html", form=form)

@app.route("/logout")
@login_required
def logout():
    logout_user()
    flash("ログアウトしました。" , category='info')
    return redirect(url_for("login"))

@app.route('/')
@login_required
def index():
    return render_template('index.html')

if __name__ == "__main__":
    app.run(debug=True)
