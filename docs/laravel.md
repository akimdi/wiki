# Запуск приложения на Laravel

### Создаём папку с проектами и сразу переходим в неё

```bash
mkdir -p projects && cd projects
```

### Команда `new` создаёт новую установку в текущем каталоге со всеми установленными зависимостями

```bash
laravel new laracast.test
```

### Переходим в папку с проектом и запускаем

```bash
cd laracast.test
```

```bash
php artisan serve
```

**Проект будет доступен по адресу `127.0.0.1:8000`**


---

---

дописать!!! 

или с nginx

https://www.digitalocean.com/community/tutorials/how-to-deploy-a-laravel-application-with-nginx-on-ubuntu-16-04

https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-16-04

https://laravel.com/docs/6.x/deployment

https://github.com/laravel/quickstart-basic

https://laravel.com/docs/5.2/quickstart

https://medium.com/@asked_io/how-to-install-php-7-2-x-nginx-1-10-x-laravel-5-6-f9e30ee30eff

https://linux4one.com/how-to-install-laravel-php-framework-with-nginx-on-debian-9/


sudo vim /etc/nginx/conf.d/laracast.test.conf


server {
         listen 80;
         listen [::]:80 ipv6only=on;
 
         # Log files for Debugging
         access_log /var/log/nginx/laravel-access.log;
         error_log /var/log/nginx/laravel-error.log;
 
         # Webroot Directory for Laravel project
         root /var/www/laracast.test/public;
         index index.php index.html index.htm;
 
         # Your Domain Name
         server_name laracast.test;
 
         location / {
                 try_files $uri $uri/ /index.php?$query_string;
         }
 
         # PHP-FPM Configuration Nginx
         location ~ \.php$ {
                 try_files $uri =404;
                 fastcgi_split_path_info ^(.+\.php)(/.+)$;
                 fastcgi_pass unix:/run/php/php7.4-fpm.sock;
                 fastcgi_index index.php;
                 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                 include fastcgi_params;
         }
 }



sudo cp -r -v /home/me/projects/laracast.test /var/www

sudo nginx -t
sudo systemctl restart nginx


open in chrome
laracast.test