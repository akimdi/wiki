# Установка PHP на Debian

### Для начала обновим систему

```bash
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove
```

*Так как в стабильной ветке Debian находятся не совсем свежие пакеты php, следует подключить сторонний репозиторий от главного php маинтейнера в Debian, поэтому за безопасность не стоит волноваться, хотя это считается не очень хорошей практикой, с точки зрения политики Debian, так как это потенциально может нарушить совместимость с какими-либо пакетам находящимися с основных репозиториях.*

*Более подробно о том что подключать сторонние репозитории это плохо, написано в статье [Advice For New Users On Not Breaking Their Debian System](https://wiki.debian.org/DontBreakDebian)*

*Кстати вот что [пишет сам разработчик:](https://deb.sury.org)*

*I am a Debian Developer since year 2000, and I have been packaging PHP for Debian since PHP 5. That means the official packages in Debian and Ubuntu are either my work or they are based on my work. The PHP packages in my Ubuntu PPA and Debian DPA matches the official packages in Debian. Basically I am saying that you can’t get any closer than that.*

### Устанавливаем зависимости для дополнительного репозитория SURY PHP PPA

```bash
sudo apt install lsb-release apt-transport-https ca-certificates -y
```

*Начиная с Debian 11 Bullseye пакет `apt-transport-https` будет удален из основных репозиториев, так как считается переходным и его функционал уже портирован в основной код пакетного менеджера `apt`. Проще говоря начиная с Debian 11 уже не надо будет устанавливать пакет `apt-transport-https`.*

### Импортируем GPG ключи

```bash
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
```

### Добавляем дополнительный репозиторий SURY PHP PPA

```bash
sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
```

### Устанавливаем PHP

```bash
sudo apt update
```

```bash
sudo apt install php7.4 -y
```

### Устанавливаем дополнительные пакеты которые нужны для работы

*Аналогично можно устанавливать любые другие пакеты которые понадобятся, типо sudo apt install php7.4-xxx. Вместо xxx добавлять те которые нужны.*

```bash
sudo apt install php7.4-bcmath php7.4-bz2 php7.4-intl php7.4-gd php7.4-mbstring php7.4-mysql php7.4-zip php7.4-fpm php7.4-xsl -y
```

### Проверяем установку PHP

```bash
php -v
```