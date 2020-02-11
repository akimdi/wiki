# Установка Сomposer в Debian

### Для начала установим зависимости

```bash
sudo apt update && sudo apt install curl php-cli php-mbstring git unzip -y
```

### Скачаиваем инсталятор хэш-суммy sha384sum

```bash
wget --https-only --output-document=composer-setup.php https://getcomposer.org/installer
```

```bash
wget --https-only --output-document=composer-setup.sha384sum https://composer.github.io/installer.sha384sum
```

### Проверяем хэш-суммy

```bash
sha384sum --ignore-missing -c composer-setup.sha384sum
```

*Или же можно воспользоваться скриптом который предлагает composer и произвести установку в [автоматическом режиме](https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md)*


### Устанавливаем Сomposer глобально в директорию `/usr/local/bin`

```bash
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
```

### Проверяем установку

```bash
composer --version
```

### Удаляем установочные файлы

```bash
rm -r -f -v composer-setup.php composer-setup.sha384sum
```

### Для примера можно [поставить laravel](https://laravel.com/docs/6.x#installing-laravel)

```bash
composer global require laravel/installer
```


### Также следует не забывать добавить переменную PATH в .bashrc или .zshrc (в зависимости от того какой стоит shell)

```bash
vim .bashrc
```

### Добавляем всё сразу 😊

```bash
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/me/bin:/home/me/.cargo/bin:/home/me/go/bin:/home/me/.config/composer/vendor/bin
```

### Также можете найти глобальный путь установки Сomposer запустив команду

```bash
composer global about
```

*Подробнее можно прочитать на [digitalocean tutorials](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-debian-10)*