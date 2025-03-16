#!/bin/bash

# ZabbixのリポジトリURLとコンフィグのパス
ZABBIX_URL="https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-latest-7.0.el9.noarch.rpm"
ZABBIX_CONF="/etc/zabbix/zabbix_server.conf"

# MariaDBのインストール
dnf install -y mariadb-server

# MariaDBの起動と自動起動設定
systemctl start mariadb
systemctl enable mariadb

# Zabbixのリポジトリを追加
rpm -Uvh "${ZABBIX_URL}"
dnf clean all

# Zabbix関連パッケージのインストール
dnf install -y zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent zabbix-web-japanese

# MariaDBへのログインパスワードの指定、ポリシーに当てはまらなければ再入力
while true; 
do
    echo "MariaDBのログインパスワードを指定してください: "
    read -s db_password
    if [[  ${#db_password} -ge 8 && "${db_password}" =~ [A-Z] && "${db_password}" =~ [a-z] && "${db_password}" =~ [0-9] ]]; then
        read -p "入力した内容が正しければ処理を続行しますが、よろしいですか？ (y/n): " confirm
        case $confirm in
            [Yy]* )  
                echo "後続の処理を実行します"
                break;;
            [Nn]* ) 
                echo "パスワードの入力をやり直します";;
            * ) 
                echo "エラー: yかnを入力してください";;
        esac
    else
        echo "エラー: パスワードは8文字以上で、英数字大文字小文字を含む必要があります"
    fi
done



# Zabbixのデータベースとユーザーの作成
mysql -uroot <<EOF
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by '${db_password}';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
EOF

# Zabbixのセットアップスクリプトの実行
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p"${db_password}" zabbix


mysql -uroot <<EOF
set global log_bin_trust_function_creators = 0;
EOF

# zabbix_server.confの設定値書き換え
sed -i "s/# DBPassword=/DBPassword=${db_password}/g" "${ZABBIX_CONF}" > /dev/null


# Zabbix ServerとAgent、Apache、PHP-FPMの再起動と自動起動設定
systemctl restart zabbix-server zabbix-agent httpd php-fpm
systemctl enable zabbix-server zabbix-agent httpd php-fpm

# firewalldの設定
firewall-cmd --add-service=http --zone=public --permanent
firewall-cmd --add-port=10051/tcp --zone=public --permanent
firewall-cmd --reload

echo "Zabbixのセットアップが完了しました。"

