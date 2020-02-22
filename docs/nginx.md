# Установка Nginx в Debian

### Для начала обновим систему

```bash
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove
```

### Отключаем Apache Server чтобы не мешал

```bash
sudo systemctl disable --now apache2
```

### Подключаем [официальный репозиторий NGINX](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/#installing-a-prebuilt-debian-package-from-the-official-nginx-repository)

```bash
sudo wget  -q -O - https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
```

```bash
sudo sh -c 'echo "deb https://nginx.org/packages/mainline/debian/ $(lsb_release -sc) nginx\ndeb-src https://nginx.org/packages/mainline/debian/ $(lsb_release -sc) nginx" > /etc/apt/sources.list.d/nginx.list'
```

```bash
sudo apt update
```

```bash
sudo apt install nginx -y
```

### После установки должно выдать что-то типо этого

```bash
Thanks for using nginx!

Please find the official documentation for nginx here:
* http://nginx.org/en/docs

Please subscribe to nginx-announce mailing list to get
the most important news about nginx:
* http://nginx.org/en/support.html

Commercial subscriptions for nginx are available on:
* http://nginx.com/products
```

### Запускаем NGINX

```bash
sudo systemctl start nginx
```

### Ставим NGINX в автозагрузку

```bash
sudo systemctl enable nginx
```

### Проверяем доступность NGINX

```bash
curl -I 127.0.0.1
```

### Должно выдать что-то типо этого

```bash
HTTP/1.1 200 OK
Server: nginx/1.17.8
```

### Проверяем статус

```bash
sudo systemctl status nginx
```

### Если нужно остановить и снова запустить службу

```bash
sudo systemctl restart nginx
```

### Если вы просто вносите изменения в конфигурацию, Nginx может часто перезагружаться, не прерывая соединения. Для этого нужно ввести команду `reload`

```bash
sudo systemctl reload nginx
```

### По умолчанию Nginx настроен на автоматический запуск при загрузке сервера. Если это не то, что нужно, то отключить это поведение, можно набрав

```bash
sudo systemctl disable nginx
```

*Подробнее можно прочитать на [digitalocean tutorials](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-debian-10)*