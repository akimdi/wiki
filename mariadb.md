# Установка MariaDB в Debian

### Для начала обновим систему

```bash
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove
```

### Устанавливаем MariaDB

```bash
sudo apt install mariadb-server mariadb-plugin-connect mariadb-common mariadb-client mariadb-test-data mariadb-test -y
```
### Запускаем скрипт настройки MariaDB

*Удаляем тестовую базу, устанавливаем пароль от root в MariaDB (не путать с пользователем root в системе).*

*Отвечаем на вопросы как показано ниже:*

```bash
sudo mysql_secure_installation
```

```bash
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none): 
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

You already have a root password set, so you can safely answer 'n'.

Change the root password? [Y/n] Y
New password: 
Re-enter new password: 
Password updated successfully!
Reloading privilege tables..
 ... Success!

By default, a MariaDB installation has an anonymous user, allowing anyone
to log into MariaDB without having to have a user account created for
them.  This is intended only for testing, and to make the installation
go a bit smoother.  You should remove them before moving into a
production environment.

Remove anonymous users? [Y/n] Y
 ... Success!

Normally, root should only be allowed to connect from 'localhost'.  This
ensures that someone cannot guess at the root password from the network.

Disallow root login remotely? [Y/n] Y 
 ... Success!

By default, MariaDB comes with a database named 'test' that anyone can
access.  This is also intended only for testing, and should be removed
before moving into a production environment.

Remove test database and access to it? [Y/n] Y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reloading the privilege tables will ensure that all changes made so far
will take effect immediately.

Reload privilege tables now? [Y/n] Y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```

### Можно посмотреть версию которая установилась

```bash
sudo mysqladmin version
```

### Запускаем службу MariaDB (MySQL)

```bash
sudo systemctl start mysqld
```

```bash
sudo systemctl enable mysqld
```

```bash
sudo systemctl status mysqld
```

### Устанавливаем пароль от root в [MariaDB (MySQL)](https://wiki.archlinux.org/index.php/MariaDB)

*Вместо `my-new-password` прописываем свой пароль.*

```bash
sudo mysqladmin -u root password "my-new-password"
```

### Логинимся из под root

```bash
sudo mysql -p -u root
```

### Создаём пользователя me

*Вместо `my-new-password` прописываем свой пароль.*

```bash
CREATE USER 'me'@'localhost' IDENTIFIED BY 'my-new-password';
```

### И даём ему все привилегии

```bash
GRANT ALL PRIVILEGES ON *.* TO 'me'@'localhost' WITH GRANT OPTION;
```

### Выходим

```bash
quit
```

### Заходим из под пользователя me

```bash
mysql -p -u me
```

### Проверяем есть ли нужные привилегии у пользователя me

```bash
SHOW GRANTS FOR CURRENT_USER;
```

### Создаём [базу](https://mariadb.com/kb/ru/create-database) laracast_test

```bash
CREATE DATABASE laracast_test;
```

### Смотрим какие есть базы

```bash
SHOW DATABASES;
```

### Выбираем нужную базу для её [использования](https://tableplus.com/blog/2018/09/mariadb-how-to-create-a-new-database-and-manage-it.html)

```bash
USE laracast_test;
```

### Выходим

```bash
quit
```

### Логинимся от имени пользователя me из под mycli

```bash
mycli -u me -h localhost laracast_test
```
***Пробуем написать что нибудь, должно быть автодополнение!***

### Выходим

```bash
quit
```

*Подробнее можно прочитать на [digitalocean tutorials](https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-debian-10)*

*[MyCLI is a command line interface for MySQL, MariaDB, and Percona with auto-completion and syntax highlighting.](https://www.mycli.net/)*

*[mycli github](https://github.com/dbcli/mycli)*