# 🐧 Установка [Arch Linux](https://www.archlinux.org/download) с нуля

### Скачиваем образ и хэш-сумму

***Для этого потребуются программы `wget` `curl` `date` `sha1sum` `md5sum`***

```bash
wget --no-cache --no-cookies --https-only --show-progress --verbose https://www.archlinux.org/iso/$(date +"%Y").$(date +"%m").01/archlinux-$(date +"%Y").$(date +"%m").01-x86_64.iso.sig https://mirrors.edge.kernel.org/archlinux/iso/$(date +"%Y").$(date +"%m").01/md5sums.txt https://mirrors.edge.kernel.org/archlinux/iso/$(date +"%Y").$(date +"%m").01/sha1sums.txt https://mirrors.edge.kernel.org/archlinux/iso/$(date +"%Y").$(date +"%m").01/archlinux-$(date +"%Y").$(date +"%m").01-x86_64.iso
```

### Проверка подписи

```bash
gpg --keyserver-options auto-key-retrieve --verify archlinux-$(date +"%Y").$(date +"%m").01-x86_64.iso.sig archlinux-$(date +"%Y").$(date +"%m").01-x86_64.iso
```

### Должно выдать что-то типо этого

```bash
gpg: Действительная подпись пользователя "Pierre Schmitz <pierre@archlinux.de>"
```

### Проверяем хэш-суммы

```bash
md5sum --ignore-missing -c md5sums.txt && sha1sum --ignore-missing -c sha1sums.txt
```

***Записываем образ на флэшку с помощью [Rufus](https://github.com/pbatard/rufus/releases/latest) или [Etcher](https://github.com/balena-io/etcher/releases/latest)***

### Вставляем флэшку, определяем её и форматируем

*Раздел флэшки (в данном примере это **/dev/sdd1**) должен быть отформатирован в FAT32.*

```bash
sudo fdisk -l | sudo grep /dev/sd
```

```bash
sudo df | sudo grep /dev/sd
```

```bash
sudo lsblk
```

```bash
sudo umount /dev/sdd1
```

```bash
sudo mkfs.vfat -n 'archlinux' -I /dev/sdd1
```

***Дальше можно воспользоваться [Etcher](https://github.com/balena-io/etcher/releases/latest)***

### В BIOS выставляем приоритет и грузимся с Archiso в EFI режиме

![](https://sun9-54.userapi.com/c854228/v854228586/110c6b/4jn1iB3pVK0.jpg)

### Чтобы посмотреть список доступных русских раскладок

```bash
ls /usr/share/kbd/keymaps/**/*.map.gz | grep ru
```

### После загрузки Archiso нужно выбрать русскую раскладку

```bash
loadkeys ru
```

### Если на материнской плате включен режим UEFI, Archiso загрузит Arch Linux соответствующим образом при помощи systemd-boot. Чтобы в этом убедиться, посмотрите содержимое каталога efivars

```bash
ls /sys/firmware/efi/efivars
```

*Если такого каталога не существует, возможно, система загружена в режиме BIOS или CSM. Для получения дополнительной информации обратитесь к руководству пользователя вашей материнской платы.*

### Соединение с Интернетом

```bash
ip a
```

### Для проводных сетевых устройств установочный образ во время загрузки автоматически включает службу dhcpcd. Соединение можно проверить с помощью утилиты ping

```bash
ping -c 3 ya.ru
```

*Если узел недоступен, остановите службу dhcpcd при помощи команды **systemctl stop dhcpcd@интерфейс**, где **интерфейс** может быть завершен по табу. Потом перейдите к [настройке сети.](https://wiki.archlinux.org/index.php/Network_configuration)*

### Синхронизация системных часов

```bash
timedatectl set-ntp true
```

### Что-бы проверить статус

```bash
timedatectl status
```

### Разбиение дисков на [разделы](https://wiki.archlinux.org/index.php/Partitioning)

*Когда запущенная система распознает накопители, они становятся доступны как блочные устройства, например, **/dev/sda** или **/dev/nvme0n1**. Чтобы посмотреть их список, используйте **lsblk** или **fdisk**. Результаты, оканчивающиеся на **rom**, **loop** и **airoot**, можно игнорировать.*

```bash
fdisk -l | grep /dev/sd
```

```bash
lsblk
```

### [Таблица разделов](https://wiki.archlinux.org/index.php/Partitioning)

*Чтобы вывести информацию из таблицы разделов определенного устройства (в данном случае это **/dev/sda**) используйте **fdisk**.*

```bash
fdisk -l /dev/sda
```

### Разметка диска:

*В данном случае /dev/sda это тот жёсткий диск, на который будет установлена система.*

```bash
cgdisk /dev/sda
```

*Создание раздела загрузчика **/boot** или **/efi.** Выберите свободное место с помощью стрелок вверх/вниз и с помощью стрелок вправо/влево нажмите **New.** Программа запросит несколько параметров.*

### При запросе First sector нажимаем Enter, так как размер по-умолчанию 2048 устраивает

```bash
First sector (2048-234455006, default = 2048):
```

### При запросе Size in sector or {KMGPT} вводим 600M

```bash
Size in sector or {KMGPT} (default = 234452959):
```

### При запросе Hex code or GUID вводим ef00

```bash
Hex code or GUID (L to show codes, Enter = 8300):
```

### При запросе Enter new partition name вводим boot

```bash
Enter new partition name, or <Enter> to use the current name:
```

*Создание раздела **swap.** Выберите свободное место в самом низу с помощью стрелок вверх/вниз и с помощью стрелок вправо/влево нажмите **New.** Программа запросит несколько параметров.*

### При запросе First sector нажимаем Enter, так как размер по-умолчанию 1230848 устраивает

```bash
First sector (1230848-234455006, default = 1230848):
```

### При запросе Size in sector or {KMGPT} вводим 4G

```bash
Size in sector or {KMGPT} (default = 233224159):
```

### При запросе Hex code or GUID вводим L для того что бы найти код swap. Как правило это число 8200.

```bash
Hex code or GUID (L to show codes, Enter = 8300):
```

*После того как нашли код swap, нужно ввести его в поле **Hex code or GUID (L to show codes, Enter = 8300). По-умолчанию это число 8200.***

### При запросе Enter new partition name вводим swap

```bash
Enter new partition name, or <Enter> to use the current name:
```

*Создание раздела **system.** Выберите свободное место в самом низу с помощью стрелок вверх/вниз и с помощью стрелок вправо/влево нажмите **New.** Программа запросит несколько параметров.*

### При запросе First sector нажимаем Enter, так как размер по-умолчанию 9619456 устраивает

```bash
First sector (9619456-234455006, default = 1230848):
```

### При запросе Size in sector or {KMGPT} нажимаем Enter

```bash
Size in sector or {KMGPT} (default = 233224159):
```

### При запросе Hex code or GUID вводим 8300.

```bash
Hex code or GUID (L to show codes, Enter = 8300):
```

### При запросе Enter new partition name вводим system

```bash
Enter new partition name, or <Enter> to use the current name:
```

### Выберите Write с помощью стрелок влево/вправо и нажмите Enter. Выйдет предупреждение о подтверждении, следует написать полностью слово yes.

```bash
Are you sure you want to write the partition table to disk? (yes or no):
```

*После с помощью стрелок влево/вправо следует выбрать **Quit** и нажать Enter что-бы выйти из программы.*

### Проверим созданные разделы

```bash
lsblk
```

### Форматируем boot раздел в FAT32

```bash
mkfs.fat -F32 /dev/sda1
```

### Форматируем swap раздел

```bash
mkswap /dev/sda2
```

```bash
swapon /dev/sda2
```

### Форматируем system раздел в EXT4

```bash
mkfs.ext4 /dev/sda3
```

### Примонтируем system раздел

```bash
mount /dev/sda3 /mnt/
```

### Создадим папку /mnt/boot

```bash
mkdir /mnt/boot
```

### Примонтируем boot раздел

```bash
mount /dev/sda1 /mnt/boot
```

### Посмотрим что получилось

```bash
df
```

### Отредактируем mirrorlist и помещаем строку с Yandex зеркалом на самый верх, так она будет в приоритете

```bash
vim /etc/pacman.d/mirrorlist
```

```bash
Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch
```

### Устанавливаем [ядро](https://www.archlinux.org/packages/core/x86_64/linux) и метапакеты [base](https://www.archlinux.org/packages/core/any/base) и [base-devel](https://www.archlinux.org/groups/x86_64/base-devel)

```bash
pacstrap /mnt base base-devel linux-lts linux-lts-headers linux-firmware dhcp dhcpcd dhcping dhclient networkmanager inetutils netctl coreutils binutils wget curl vim nano zsh htop git openssh intel-ucode chezmoi
```

```bash
genfstab -U /mnt
```

### Записываем в fstab полученную новую информацию о дисках

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

```bash
cat /mnt/etc/fstab
```

### Переходим к корневому каталогу новой системы

```bash
arch-chroot /mnt
```

### Задаём часовой пояс

```bash
ln -sf /usr/share/zoneinfo/Europe/Mocsow /etc/localtime
```

### Запустите hwclock чтобы сгенерировать /etc/adjtime

```bash
hwclock --systohc
```

*Эта команда предполагает, что аппаратные часы настроены в формате UTC. Для получения дополнительной информации смотрите раздел [**время**](https://wiki.archlinux.org/index.php/System_time)*

### Включите `en_US.UTF-8 UTF-8` и `ru_RU.UTF-8 UTF-8` локали, [раскомментировав](https://ru.stackoverflow.com/a/1199612) их в файле `/etc/locale.gen` после чего сгенерируйте их:

```bash
vim /etc/locale.gen
```

```bash
locale-gen
```

### Создайте файл locale.conf и задайте необходимое значение в нем для переменной `LANG`:

```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### Настройка сети. Создаём файл hostname

```bash
echo "pc" > /etc/hostname
```

### Задаем пароль от root

```bash
passwd
```

### Добавляем пользователя me

```bash
useradd -g users -G wheel,storage,power -m me
```

### Добавляем GRUB

```bash
pacman -S grub efibootmgr os-prober
```

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

### Меняем ```GRUB_TIMEOUT``` если не хотите чтобы Arch грузился автоматически через [5 секунд ожидания на экране Grub](https://gist.github.com/tz4678/bd33f94ab96c96bc6719035fcac2b807#%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-grub)


```bash
sudo nano /etc/default/grub
```

```bash
GRUB_TIMEOUT=0
```

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Дальше мы выходим из chroot и перезагружаем машину

```bash
exit
```

```bash
sudo shutdown -r 0
```

*После перезагрузки входим из под пользователя **root***

### Проверяем работает ли DHCP сервер

```bash
sudo ip addr show
```

### Должно выдать что-то типо такого


```bash
enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether c8:60:00:52:57:26 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.254/24 brd 192.168.1.255 scope global dynamic noprefixroute enp4s0
       valid_lft 233355sec preferred_lft 233355sec
    inet6 fe80::a4d5:9574:fca7:fe7c/64 scope link noprefixroute
    valid_lft forever preferred_lft forever
```

### А если же выдало что-то типо этого, значит DHCP сервер не поднялся

```bash
enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether c8:60:00:52:57:26 brd ff:ff:ff:ff:ff:ff
```

### Тогда следует поднять DHCP сервер и поставить его на автозапуск

*В данном случае сетевой интерфейс это **enp3s0** (у некоторых он может отличаться) и мы его номер будем прописывать на старте*

```bash
sudo systemctl enable dhcpcd@enp3s0
```

```bash
sudo systemctl start dhcpcd@enp3s0
```

```bash
sudo systemctl status dhcpcd@enp3s0
```

```bash
sudo ip addr show
```

### Задаём пароль от me

```bash
sudo passwd me
```

### Полностью обновляем систему

```bash
sudo pacman -Syyu --needed
```

### Редактируем файл [/etc/sudoers](https://raw.githubusercontent.com/akimdi/help-install-arch/master/sudoers)

```bash
sudo nano /etc/sudoers
```

### Раскомментируем строки с wheel и sudo

```bash
%wheel ALL=(ALL) ALL
```

```bash
%sudo	ALL=(ALL) ALL
```

### Перезапускаем систему

```bash
sudo shutdown -r 0
```

# На этом минимальная настройка завершена. Дальше пойдет инструкция по установки дополнительного программного обеспечения, шрифтов, а также WM. Вы не должны следовать дальнейшим инструкциям, так как для каждого пользователя они будут разные. Эта конкретно - для меня.

### Создание любой папки с [tmpfs в ОЗУ](https://wiki.archlinux.org/index.php/Tmpfs)

```bash
sudo -i
```

```bash
mkdir /home/me/ram
```

```bash
groupadd tmpdriveusers
```

```bash
usermod -a -G tmpdriveusers me
```

### Меняем владельца папки **/home/me/ram** и даем группе **tmpdriveusers** права на запись

```bash
chown root:tmpdriveusers /home/me/ram
```

```bash
chmod 777 /home/me/ram
```

### Создаем новый **ram-диск** в папке **/home/me/ram**

```bash
sudo printf "tmpfs /home/me/ram tmpfs nodev,nosuid,size=32G 0 0" >> /etc/fstab
```

*Добавляем в конец файла **/etc/fstab** такую строку, параметр size означает сколько нужно выделить из оперативной памяти под RAM диск, в данном случае это 16gb - то есть всю ОЗУ.*

### Перезапускаем систему

```bash
sudo shutdown -r 0
```

*После перезагрузки убеждаемся в том, что RAM-диск смонтирован и к нему есть доступ. В листинге команды mount должна присутствовать строка **“tmpfs on /home/me/ram type tmpfs (rw)”**.*

```bash
sudo mount | grep ram
```

### Убедиться в том, что ram-disk реально доступен для записи обычному пользователю, можно создав на нём новый файл

```bash
echo hi-akimdi > /home/me/ram/temp.txt && cat /home/me/ram/temp.txt
```

***При выключении компьютера ОЗУ очищается и всё что находилось в этой папке будет удалено!***

### Правим файл [/etc/pacman.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/pacman.conf)

```bash
sudo vim /etc/pacman.conf
```

### Самое главное чтобы раскомментировать строки относящиеся к репозиториям `extra` `community` `multilib`

```bash
#
# File /etc/pacman.conf
#
# See the pacman.conf(5) manpage for option and repository directives
#
# GENERAL OPTIONS
#
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
#HookDir     = /etc/pacman.d/hooks/
HoldPkg     = pacman glibc
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
Color
TotalDownload
CheckSpace
VerbosePkgLists

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

# NOTE: You must run `pacman-key --init` before first using pacman; the local
# keyring can then be populated with the keys of all official Arch Linux
# packagers with `pacman-key --populate archlinux`.

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have $repo replaced by the name of the current repo
#   - URLs will have $arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

#[testing]
#Include = /etc/pacman.d/mirrorlist

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

#[community-testing]
#Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

# If you want to run 32 bit applications on your x86_64 system,
# enable the multilib repositories as required here.

#[multilib-testing]
#Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs
```

### Или чтобы не редактировать можно просто скачать файл [/etc/pacman.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/pacman.conf)

```bash
sudo wget --https-only --output-document=/etc/pacman.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/pacman.conf
```

### Также можно скачать файл [/etc/pacman.d/mirrorlist](https://raw.githubusercontent.com/akimdi/help-install-arch/master/mirrorlist)

```bash
sudo wget --https-only --output-document=/etc/pacman.d/mirrorlist https://raw.githubusercontent.com/akimdi/help-install-arch/master/mirrorlist
```

### Нужно обязательно обновить пакеты и кэш после редактирования этих файлов

```bash
sudo pacman -Syyuu --needed
```

### Устанавливаем необходимые пакеты из [списка](https://superuser.com/q/1061612) в [файле](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks)

```bash
sudo wget -O /home/me/ram/pkglist.txt https://raw.githubusercontent.com/akimdi/help-install-arch/master/pkglist.txt
```

```bash
sudo pacman -S --needed - < /home/me/ram/pkglist.txt
```

```bash
sudo rm -v /home/me/ram/pkglist.txt
```

### Или можно установить эти пакеты из командной строки

```bash
sudo pacman -S --needed inetutils sudo base base-devel linux-lts linux-lts-headers netctl coreutils binutils dhcp dhclient dhcping fd mlocate dwdiff wdiff the_silver_searcher ripgrep ack percol tar less most mc findutils diffutils grep sed gawk util-linux procps-ng psmisc cmake make shadow gcc lld lldb openjdk-src openjdk-doc jre-openjdk jdk-openjdk icedtea-web icedtea-web-doc vim-plugins jdk11-openjdk openjdk11-doc openjdk11-src visualvm doxygen doxygen-docs fastjar perl-file-mimeinfo freemind swt mill kitty alacritty rxvt-unicode xterm abduco dvtm screen tmux trash-cli nnn fff ranger vifm nemo thunar rclone p7zip zip rsync grsync file-roller colordiff diffuse kdiff3 kompare meld gprename krename perl-rename gnome-search-tool kfind mate-utils regexxer exa lsd tree bat termdown bmon figlet slop goaccess moreutils smartmontools cpio libarchive nawk htop recoll git gnome-builder kdevelop lazarus lazarus-qt5 fpc fpc-src netbeans unzip massif-visualizer nemiver scanmem gameconqueror sysprof flex byacc bison peg ragel kde-dev-utils phonon-qt5-gstreamer phonon-qt5 pulseaudio glade fltk ghex okteta jshon jq yq umbrello devhelp kcharselect gucharmap gnome-characters parted gnome-disk-utility gparted partitionmanager btrfs-progs arch-install-scripts dosfstools exfat-utils f2fs-tools xdg-desktop-portal-gtk e2fsprogs jfsutils nilfs-utils ntfs-3g udftools reiserfsprogs xfsprogs ecryptfs-utils unionfs-fuse clonezilla fsarchiver partclone partimage udevil udiskie udisks2 kdf filelight poke baobab ncdu gdmap testdisk foremost ext4magic gsmartcontrol libatasmart sweeper rmlint-shredder rmlint fdupes bleachbit gnome-multi-writer gnome-system-monitor xfce4-taskmanager mate-system-monitor lxtask ksysguard gnome-usage psensor xsensors conky conky-manager usbview kinfocenter lshw hardinfo nmon screenfetch neofetch hwinfo hwdetect dmidecode archey3 pacmanlogviewer ksystemlog gnome-system-log gnome-logs xorg-xman khelpcenter yelp gnome-remote-desktop gnome-font-viewer kcron cronie ktimer kshutdown chrony light gnome-color-manager displaycal argyllcms redshift sxhkd xsel cups-pdf cups bluez-cups system-config-printer print-manager xdg-utils blueman blueberry bluedevil gnome-bluetooth bluez-utils acpid acpi powertop tlp tlp-rdw lostfiles firefox firefox-developer-edition chromium opera upower wire-desktop wireless_tools wireshark-cli wireshark-qt kismet wifite wpa_supplicant cowpatty abook pacmatic pkgfile aria2 uget curl wget reflector pcurses ca-certificates ca-certificates-mozilla tor stow openssl xclip xorg-xclipboard pluma iotop net-tools rofi vim neovim neovim-qt kbd terminus-font adobe-source-code-pro-fonts awesome-terminal-fonts ttf-dejavu ttf-liberation dosbox metasploit telegram-desktop libreoffice-fresh libreoffice-fresh-ru libreoffice-extension-texmaths libreoffice-extension-writer2latex lyx mythes kleopatra ncrack gimp gimp-help-ru potrace pdfmixtool ffmpeg ffmpeg2theora opera-ffmpeg-codecs ffmpegthumbs ffmpegthumbnailer gnome-video-effects pdfmod mupdf mupdf-tools paperwork pdf2djvu pdf2svg pdfcrack pdftricks qpdf qpdfview wkhtmltopdf xpdf diffpdf zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps epdfview evince gscan2pdf gv img2pdf mpv cgit git-annex git-crypt gitg git-latexdiff gitolite gitprompt-rs git-repair tig qgit krita chezmoi kate ark adwaita-icon-theme fakeroot qmmp okular links youtube-dl imagemagick aws-cli pandoc cgrep mkvtoolnix-gui mkvtoolnix-cli rust rust-docs rust-bindgen rust-racer gedit gedit-plugins autossh openssh zsh zsh-doc zsh-lovers libvirt-glib libvirt-python perl-sys-virt dkms polkit virt-manager virt-install qemu qemu-arch-extra qemu-block-gluster qemu-block-iscsi qemu-block-rbd qemu-guest-agent unicorn android-tools android-file-transfer android-udev ttf-droid speedtest-cli cmatrix openshot sox mps-youtube zim optipng hicolor-icon-theme arc-icon-theme audacious audacious-plugins flac i7z gnome-icon-theme gnome-icon-theme-extras gnome-icon-theme-symbolic ttf-fira-sans ttf-fira-mono ttf-ionicons ttf-font-awesome perl-json-xs pass pass-otp rofi-pass pwgen qtpass xournalpp crash pgpdump tcpdump tcptrace xfsdump xorg-xpr scrot networkmanager openvpn pptpclient wireguard-tools shadowsocks shadowsocks-qt5 stunnel elinks lynx w3m falkon qutebrowser min vimb midori axel you-get youtube-viewer mps-youtube nextcloud-client filezilla rtorrent gist pastebinit neomutt mutt fdm procmail offlineimap fractal wavpack a52dec celt libmad lame obs-studio kdenlive gaupol cmus opus libvorbis opencore-amr speex faac faad2 libfdk-aac jasper openjpeg2 aom dav1d rav1e schroedinger libdv x265 libde265 x264 libmpeg2 libtheora libvpx ogmtools remmina toxcore tuntox toxic qtox eom eog feh geeqie gwenview fbida nomacs qiv sxiv viewnior vimiv gnome-photos digikam python-cairosvg converseen graphicsmagick gmic guetzli xloadimage jpegoptim optipng fbida fbv darktable flameshot diskus gnome-screenshot maim gpick kcolorchooser gcolor3 gcolor2 sweethome3d fontforge calligra calligra-plan inkscape gnome-calculator speedcrunch dia rawtherapee moc mpg123 xmms2 beets soundconverter audacity gnome-sound-recorder sweep kwave alsa-utils qastools gnac ecasound picard quodlibet easytag mp3unicode mp3info id3v2 gst-plugins-base-libs minitube smtube transmageddon handbrake handbrake-cli ciano transcode mencoder avidemux-cli avidemux-qt subtitleeditor gaupol gnome-subtitles aegisub subdownloader subdl shotcut pitivi blender simplescreenrecorder recordmydesktop peek xdiskusage byzanz zart v4l-utils motion kamoso cheese perl-image-exiftool exiv2 jhead mediainfo mediainfo-gui libsndfile android-file-transfer gnokii gnome-phone-manager kdeconnect gammu pacgraph acetoneiso2 brasero k3b libdvdread libdvdcss libdvdnav gnome-maps gnome-documents gnome-calendar gnome-terminal simple-scan cool-retro-term tilix sparkleshare syncthing codeblocks libatasmart glabels scribus abiword vis kakoune kak-lsp xed leafpad beaver nano joe e3 gnumeric libgda kexi txt2tags asciidoc asciidoctor ascii asciinema asciiquarium banner txt2man vbindiff container-diff diff-so-fancy xdelta3 containerd vagrant molecule-vagrant packer libvirt virt-viewer gnome-boxes cpupower minikube kubectl k9s kubectx pinfo texmaker gnome-latex minted gummi qtikz ktikz auto-multiple-choice dblatex dot2tex hevea kile latex2html latex2rtf otf-latin-modern otf-latinmodern-math python-docutils python-latexcodec rubber sagetex texlive-bin texlive-langchinese texlive-langcyrillic texlive-langextra texlive-langgreek texlive-langjapanese texlive-langkorean texlive-bibtexextra texlive-core texlive-fontsextra texlive-formatsextra texlive-games texlive-humanities texlive-latexextra texlive-music texlive-pictures texlive-pstricks texlive-publishers texlive-science texstudio gnome-chess supertux supertuxkart josm calc khal remind when gnome-clocks armagetronad arc-gtk-theme qmapshack desktop-file-utils gpicview kuickshow gnome-todo noto-fonts-extra hostapd jad jadx groovy ant java11-openjfx java11-openjfx-src java11-openjfx-doc java-avalon-framework java-bcel jruby kotlin gradle jython maven scala xalan-java xerces2-java acme-tiny monit git-lfs git-review lolcat gnome-tweaks datamash clusterssh archlinux-wallpaper wallutils imlib2 strace svt-av1 gc dos2unix pango unrar ack newsboat swig mpop entr gyp sshfs duplicity bash wpscan unoconv ghi libtorrent xz ncurses source-highlight dbeaver dbeaver-plugin-apache-poi dbeaver-plugin-batik dbeaver-plugin-bouncycastle dbeaver-plugin-office dbeaver-plugin-sshj dbeaver-plugin-sshj-lib dbeaver-plugin-svg-format httpie calibre displaycal gnome-control-center vegeta whois lximage-qt parallel shellcheck adapta-gtk-theme compsize grub-btrfs snap-pac snapper acl snap-sync syslinux haskell-doctemplates haskell-pandoc-types pandoc-crossref python-pypandoc python-pandocfilters clang llvm openmp compiler-rt badtouch arch-audit hexyl skim sd vivid watchexec smali dgen-sdl yabause-qt yelp-tools yasm cuneiform python-pyocr archivetools archlinux-keyring asp which vi autoconf automake groff gzip libtool m4 pacman patch pkgconf systemd texinfo bzip2 cryptsetup popt device-mapper argon2 dhcpcd file filesystem gcc-libs gettext iproute2 iputils licenses linux-firmware logrotate lvm2 man-db man-pages mdadm pciutils perl s-nail sysfsutils systemd-sysvcompat usbutils glibc java-rxtx java-runtime-common retext setconf bbe bluefish dconf-editor ed jedit kid3-qt l3afpad mousepad snd translate-shell hedgewars clipgrab lollypop atomicparsley aspell aspell-ca aspell-cs aspell-de aspell-el aspell-en aspell-es aspell-fr aspell-hu aspell-it aspell-nb aspell-nl aspell-nn aspell-pl aspell-pt aspell-ru aspell-sv aspell-uk linux-tools bpf cgroup_event_listener hyperv libtraceevent perf zzuf radamsa tmon turbostat usbip x86_energy_perf_policy ltris xreader almanah texlive-most texlive-lang drawing ncmpcpp ncmpc linssid tuxcmd diffoscope cantata ario mpc xfmpc htmldoc veracrypt wgetpaste xorg-apps xorg-bdftopcf xorg-iceauth xorg-mkfontscale xorg-sessreg xorg-setxkbmap xorg-smproxy xorg-x11perf xorg-xauth xorg-xbacklight xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma xorg-xhost xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo xorg-xwud xorg-fonts xorg-fonts-encodings xorg-font-util mesa-demos fio hyperfine netperf siege sysbench bonnie++ hdparm iperf iperf3 libdca libmpcdec libwebp qt5-imageformats fdkaac xvidcore xine-lib xine-ui gst-libav intel-ucode iucode-tool pv ddrescue gmock noto-fonts ttf-croscore noto-fonts-cjk earlyoom noto-fonts-emoji ttf-caladea ttf-carlito ttf-opensans ttf-roboto yubioath-desktop kstars moserial rox screengrab utox rawdog zstd gnome-autoar expat zshdb readline paxtest lynis arch-wiki-docs ngrep llpp gst-plugins-bad gst-plugins-good gst-plugins-ugly intel-gmmlib dehydrated hydra exploitdb pixiewps bettercap bettercap-caplets hashcat hashcat-utils cifs-utils iw aircrack-ng fcrackzip john ophcrack pyrit cracklib nmap vulscan fping ghostpcl ghostscript ghostxps borgmatic borg hddtemp whowatch mesa intel-media-driver adriconf vulkan-intel vulkan-icd-loader ocl-icd intel-compute-runtime xf86-input-evdev xf86-input-libinput xf86-input-synaptics xf86-input-void vdpauinfo vim-latexsuite sslsplit sslscan sqlmap nikto mitmproxy masscan swaks tcpreplay netbrake hashdeep ifenslave minicom picocom tinyserial lftp evilginx dnscrypt-proxy dns-over-https jnettop arp-scan rink ctags mtr traceroute mkinitcpio linuxconsole bsdiff texworks vapoursynth nemo-seahorse seahorse nvchecker mftrace ttf-cascadia-code ttf-cormorant ttf-fantasque-sans-mono ttf-fira-code ttf-inconsolata ttf-proggy-clean ttf-roboto-mono ttf-ubuntu-font-family progress fvextra iso-codes terraform syntax-highlighting nano-syntax-highlighting python-qrcode nfs-utils firewalld dnsmasq tinyemu dosemu multitail bomber asciiportal namcap expac naev astromenace babeltrace dnstracer extremetuxracer grc imwheel xorg-appres xorg-docs xorg-fonts-cyrillic xorg-fonts-misc xorg-fonts-type1 xorg-oclock xorg-server xorg-server-common xorg-server-devel xorg-server-xephyr xorg-server-xnest xorg-server-xvfb xorg-twm xorg-util-macros xorg-xbiff xorg-xcalc xorg-xclock xorg-xconsole xdm-archlinux xorg-xdm autorandr xorg-xedit xorg-xeyes xorg-xfd xorg-xfontsel xorg-xinit xorg-xload xorg-xlogo xorg-xlsfonts xorg-xmag xorg-xmessage xorg-xvidtune i3-gaps py3status i3blocks dmenu rofi perl-anyevent-i3 rng-tools nyx sigal qbittorrent sssd trojan mailcap zbar detox qrencode qreator sysstat kcptun rsnapshot ext3grep docx2txt lrzip pdftk pdfgrep duperemove snappy lz4 lzip xarchiver lzop lzo atool arj par2cmdline sharutils brotli zlib unarchiver djvulibre tesseract gimagereader-qt gimagereader-common quiterss tesseract-data tesseract-data-tha tesseract-data-tir tesseract-data-tur tesseract-data-uig tesseract-data-ukr tesseract-data-urd tesseract-data-uzb tesseract-data-uzb_cyrl tesseract-data-vie tesseract-data-yid tesseract-data-lat tesseract-data-lav tesseract-data-lit tesseract-data-mal tesseract-data-mar tesseract-data-mkd tesseract-data-mlt tesseract-data-msa tesseract-data-mya tesseract-data-nep tesseract-data-nld tesseract-data-nor tesseract-data-ori tesseract-data-pan tesseract-data-pol tesseract-data-por tesseract-data-pus tesseract-data-ron tesseract-data-rus tesseract-data-san tesseract-data-sin tesseract-data-slk tesseract-data-slk_frak tesseract-data-slv tesseract-data-spa tesseract-data-spa_old tesseract-data-sqi tesseract-data-srp tesseract-data-srp_latn tesseract-data-swa tesseract-data-swe tesseract-data-syr tesseract-data-tam tesseract-data-tel tesseract-data-tgk tesseract-data-tgl tesseract-data-afr tesseract-data-amh tesseract-data-ara tesseract-data-asm tesseract-data-aze tesseract-data-aze_cyrl tesseract-data-bel tesseract-data-ben tesseract-data-bod tesseract-data-bos tesseract-data-bul tesseract-data-cat tesseract-data-ceb tesseract-data-ces tesseract-data-chi_sim tesseract-data-chi_tra tesseract-data-chr tesseract-data-cym tesseract-data-dan tesseract-data-dan_frak tesseract-data-deu tesseract-data-deu_frak tesseract-data-dzo tesseract-data-ell tesseract-data-eng tesseract-data-enm tesseract-data-epo tesseract-data-equ tesseract-data-est tesseract-data-eus tesseract-data-fas tesseract-data-fin tesseract-data-fra tesseract-data-frk tesseract-data-frm tesseract-data-gle tesseract-data-glg tesseract-data-grc tesseract-data-guj tesseract-data-hat tesseract-data-heb tesseract-data-hin tesseract-data-hrv tesseract-data-hun tesseract-data-iku tesseract-data-ind tesseract-data-isl tesseract-data-ita tesseract-data-ita_old tesseract-data-jav tesseract-data-jpn tesseract-data-kan tesseract-data-kat tesseract-data-kat_old tesseract-data-kaz tesseract-data-khm tesseract-data-kir tesseract-data-kor tesseract-data-kur tesseract-data-lao cppcheck check rstcheck rkhunter enchant ipguard libpcap arpwatch bully darkstat dsniff etherape ettercap pth net-snmp iftop hcxtools hping lorcon p0f zmap libsrtp languagetool reprotest disorderfs yapf splint afew alot notmuch notmuch-mutt notmuch-runtime notmuch-vim sylpheed m2r pelican python-pybtex-docutils python-recommonmark python-cloudflare certbot-dns-google certbot-dns-digitalocean certbot-dns-ovh certbot-nginx certbot acme.sh certbot-dns-cloudflare hcloud minio s3cmd s3fs-fuse abcde arduino arduino-avr-core arduino-builder arduino-cli arduino-ctags arduino-docs reaver slowhttptest thc-ipv6 mcabber testssl.sh xca bsd-games cadaver castget dateutils gifsicle hopenpgp-tools mailutils lxsplit mednafen mdp mktorrent mp3splt pamixer pngquant skopeo snarf task vit timew tldr unrtf wavegain yad afl atril cpuburn jpegexiforient libexif python-piexif urlwatch abuse aisleriot blobwars blobwars-data bzflag cuyo tuxcards ksnakeduel ksirk lincity-ng ufw ufw-extras iptstate frozen-bubble gnuchess xboard usleep ktorrent pan photoflare rssguard synbak shotgun spectacle fbgrab ferm ipset bridge-utils openbsd-netcat packeth zaproxy nitrogen acpi_call glu fbset prettyping lesspipe colorgcc expect ccze xdotool xautomation navit merkaartor stellarium xxkb evtest xcape otf-fantasque-sans-mono croc uncrustify elisa macchanger horst wavemon tzdata ppp ndisc6 syslog-ng gnome-nettool debian-archive-keyring gnome-keyring minizip keyutils gnupg gpa gpg-crypter kgpg ubuntu-keyring gpm badvpn chntpw beep echoping httping ioping quilt scrapy smokeping vym wipe xkbsel medusa otter-browser otf-overpass hcxkeys pinentry posterazor ncompress gperftools heaptrack otf-fira-mono otf-fira-sans uchardet qcachegrind remake rofimoji pacman-contrib pacman-mirrorlist chromium-bsu pydf nss clojure graphviz xmldiff pkgdiff pygmentize python-pygments s-tui sonic-visualiser barcode zint zint-qt gnome-music nyancat supervisor bochs ipmitool iptraf-ng ipv6calc ipvsadm pigz pstotext psutils teeworlds munin urlscan go go-tools asunder goobox whipper lire nethack glhack osquery xapps imvirt cantor kalgebra libqalculate qalculate-gtk baloo keepassxc kwallet rdesktop gopass firetools firejail pngquant atop xtrabackup findomain sn0int pppusage modemmanager variety dunst consul consul-template mysql-workbench modem-manager-gui ruby-rouge mytop innotop samba spice spice-gtk spice-protocol spice-vdagent avfs jp2a ttf-joypixels profile-sync-daemon anything-sync-daemon usbguard sl gn brightnessctl svgcleaner glances python-numpy python-numpydoc fftw dhex alsa-lib iniparser paprefs ponymix pulsemixer freeimage mpd rshijack words fzf wmctrl edk2-ovmf inotify-tools gpxsee virtualbox-guest-utils virtualbox-guest-iso virtualbox virtualbox-host-dkms molecule awxkit ansible-lint ansible-bender ansible kustomize tbb paperkey luksmeta deheader crun xf86-video-intel xf86-video-vesa foliate intel-undervolt gcc-objc gcc-fortran gcc-d gcc-ada aarch64-linux-gnu-gcc bashbrew runc buildah toolbox ddcutil yamllint element-desktop element-web rocs kwrite kwalletmanager ktouch kolourpaint knotes kget keditbookmarks kalarm docker docker-compose docker-machine argocd-cli fluxctl helm kubeone popeye arandr github-cli cgdb proxychains-ng torbrowser-launcher torsocks libsysstat fwupd gnome-firmware kirigami-gallery plasma-systemmonitor bpftrace git-filter-repo slock sshguard ghostwriter marker notes-up mdcat dua-cli stratis-cli stratisd sequoia sequoia-keyring-linter physlock pam xss-lock xsecurelock xscreensaver xlockmore nbd mlt fossil treeify sddm filebin netbeans geogebra leptonica djview umockdev mopidy tmate texlab hwids awstats aws-vault unp ethtool miniserve argbash advancecomp aerc afl-utils profile-cleaner lmms terragrunt terraform-provider-libvirt vault alicloud-vault mediastreamer oxipng urjtag picom hsetroot metapixel pixz mypaint pinta tmuxp pdfslicer lifeograph vidcutter audit onefetch sigutils kube-apiserver kube-controller-manager kube-proxy kube-scheduler kubeadm kubelet tanka web-ext gammastep uutils-coreutils gifski repo taskell gping dump_syms unicode-emoji caribou units ali cargo-c cargo-fuzz mkcert cargo-release mdbook sniffglue rust-analyzer step-cli toastify cargo-audit cargo-edit cargo-outdated cargo-tarpaulin cargo-watch catfish kdiagram haproxy gufw conmon cri-o helmfile vals giac libgiac xcas kubeseal nvtop kvazaar swappy dhall dhall-bash dhall-json dhall-lsp-server dhall-yaml run-parts nftables fbreader cherrytree deadbeef bpytop archlinux-repro onionshare privoxy containers-common qtqr starship firefox-spell-ru texmacs netsurf surfraw ttf-anonymous-pro rednotebook archiso celestia vocal spice-up pantheon-calendar pidgin pidgin-otr pidgin-talkfilters pidgin-xmpp-receipts purple-skypeweb ostree igmpproxy imv crictl critest signal-desktop tracker hefur urh notify-osd libnotify cutter n2n warpinator wabt viking
```

### Проверка обновления [микрокода Intel](https://wiki.archlinux.org/index.php/Microcode)

```bash
sudo dmesg | sudo ag microcode
```

### Должно выдать что-то похожее на следующее, что указывает на то, что микрокод обновляется при ранней загрузке

```bash
[    0.000000] CPU0 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.221951] CPU1 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.242064] CPU2 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.262349] CPU3 microcode updated early to revision 0x1b, date = 2014-05-29
[    0.507267] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507272] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507276] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507281] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507286] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507292] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507296] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507300] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x1b
[    0.507335] microcode: Microcode Update Driver: v2.2.
```

### Настраиваем время с помощью [Chrony](https://wiki.archlinux.org/index.php/Chrony)

```bash
sudo -i
```

```bash
sudo systemctl start chronyd.service
```

### Ставим Chrony в автозагрузку

```bash
sudo systemctl enable chronyd.service
```

### Проверяем статус

```bash
sudo systemctl status chronyd.service
```

### Добавляем строки в файл [/etc/chrony.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/chrony.conf)

```bash
sudo vim /etc/chrony.conf
```

```bash
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst
```

### Или что бы не вписывать можно скачать конфигурационный файл Chrony

```bash
sudo wget --https-only --output-document=/etc/chrony.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/chrony.conf
```

```bash
sudo chronyc -a makestep
```

```bash
sudo chronyc activity
```

```bash
sudo chronyc tracking
```

```bash
sudo shutdown -r 0
```

```bash
date
```

### Добавляем строки в файл [/etc/hosts](https://raw.githubusercontent.com/akimdi/help-install-arch/master/hosts)

```bash
sudo vim /etc/hosts
```

```bash
127.0.0.1 localhost
::1 localhost
127.0.1.1 pc.localdomain pc
```

### Или что бы не вписывать можно скачать файл hosts

```bash
sudo wget --https-only --output-document=/etc/hosts https://raw.githubusercontent.com/akimdi/help-install-arch/master/hosts
```

### Настройка [русской локали](https://wiki.archlinux.org/index.php/Locale)

```bash
sudo -i
```

```bash
sudo printf "ru_RU.UTF-8 UTF-8\nen_US.UTF-8 UTF-8" > /etc/locale.gen
```

### Или что бы не вписывать можно скачать файл [/etc/locale.gen](https://raw.githubusercontent.com/akimdi/help-install-arch/master/locale.gen)

```bash
sudo wget --https-only --output-document=/etc/locale.gen https://raw.githubusercontent.com/akimdi/help-install-arch/master/locale.gen
```

### [Генерируем эти две локали](https://archlinux.org.ru/forum/topic/16293)

```bash
sudo locale-gen
```

### Cмотрим что они действительно сгенерировались и теперь присутствуют в системе

```bash
sudo localectl list-locales
```

### Устанавливаем локаль которая будет основной (выбирается из сгенерированных)

```bash
sudo localectl set-locale LANG="ru_RU.UTF-8"
```

***Переменная LANG также автоматически пропишется в файл /etc/locale.conf***

### Смотрим чтобы выбранная локаль стала основной

```bash
sudo localectl
```

### Правим файл [/etc/locale.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/locale.conf)

```bash
sudo vim /etc/locale.conf
```

```bash
LANG=en_US.UTF-8
LANG=ru_RU.UTF-8
```

### Или что бы не вписывать можно скачать файл [/etc/locale.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/locale.conf)

```bash
sudo wget --https-only --output-document=/etc/locale.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/locale.conf
```

### Настройка [русской консоли](https://wiki.archlinux.org/index.php/Localization)

```bash
sudo vim /etc/vconsole.conf
```

```bash
LOCALE="ru_RU.UTF-8"
KETMAP="ruwin_alt_sh-UTF-8"
FONT="ter-v16n"
CONSOLEMAP=""
TIMEZONE="Europe/Moscow"
HARDWARECLOCK="UTC"
USECOLOR="yes"
```

### Или что бы не вписывать можно скачать файл [/etc/vconsole.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/vconsole.conf)

```bash
sudo wget --https-only --output-document=/etc/vconsole.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/vconsole.conf
```

### Перезагружаемся

```bash
sudo shutdown -r 0
```

### Настрока [xinitrc](https://wiki.archlinux.org/index.php/Xinit)

```bash
cp --verbose /etc/X11/xinit/xinitrc /home/me/.xinitrc
```

### В самом конце файла должны написать `exec i3`

```bash
vim /home/me/.xinitrc
```

```bash
exec i3
```

### И создать пустой файл /home/me/.Xauthority

```bash
touch /home/me/.Xauthority
```

### Или что бы не вписывать можно скачать файл [/home/me/.xinitrc](https://raw.githubusercontent.com/akimdi/help-install-arch/master/.xinitrc) и файл [/home/me/.Xauthority](https://raw.githubusercontent.com/akimdi/help-install-arch/master/.Xauthority)

```bash
wget --https-only --output-document=/home/me/.xinitrc https://raw.githubusercontent.com/akimdi/help-install-arch/master/.xinitrc
```

```bash
wget --https-only --output-document=/home/me/.Xauthority https://raw.githubusercontent.com/akimdi/help-install-arch/master/.Xauthority
```

### Перезагружаемся

```bash
sudo shutdown -r 0
```

### После перезагрузки можно запустить X-сервер следующей командой

```bash
startx
```

### Настраиваем [графический драйвер Intel](https://youtu.be/zEhAJMQYSws)

```bash
sudo vim /etc/X11/xorg.conf.d/20-intel.conf
```

```bash
Section "Device"
   Identifier  "Intel Graphics"
   Driver      "intel"
   Option      "TearFree" "true"
   Option      "AccelMethod" "sna"
EndSection
```

### Или что бы не вписывать можно скачать файл [/etc/X11/xorg.conf.d/20-intel.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/20-intel.conf)

```bash
sudo wget --https-only --output-document=/etc/X11/xorg.conf.d/20-intel.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/20-intel.conf
```

### Настраиваем [разрешение экрана](https://wiki.archlinux.org/index.php/Xrandr)

```bash
sudo vim /etc/X11/xorg.conf.d/10-monitor.conf
```

```bash
Section "Monitor"
    Identifier "DP1"
    Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
    Option "PreferredMode" "1920x1080_60.00"
EndSection

Section "Screen"
    Identifier "Screen0"
    Monitor "DP1"
    DefaultDepth 24
    SubSection "Display"
        Modes "1920x1080_60.00"
    EndSubSection
EndSection

Section "Device"
    Identifier "Device0"
    Driver "intel"
EndSection
```

### Или что бы не вписывать можно скачать файл [/etc/X11/xorg.conf.d/10-monitor.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/10-monitor.conf)

```bash
sudo wget --https-only --output-document=/etc/X11/xorg.conf.d/10-monitor.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/10-monitor.conf
```

### Проверить графику можно по тестам на тиринг и следующей командой

```bash
sudo glxgears -info
```

[Web browser "VSYNC synchronization" tester](https://www.vsynctester.com)

[The effect of web browser "Input Lag" in HTML5 games](https://www.vsynctester.com/game.html)

[HTML/JavaScript mouse input performance tests](https://www.vsynctester.com/testing/mouse.html)

[displayhz](https://www.displayhz.com)

[Web browser "GPU memory usage" tester](https://www.vsynctester.com/gputest.html)

[Discover your display's VSYNC refresh rate](https://www.vsynctester.com/detect.html)

[Video tearing and smoothness test @60fps](https://youtu.be/cuXsupMuik4)

[Tearing test @60fps](https://youtu.be/0RvIbVmCOxg)

[tearing test @29.97 fps 1080p](https://youtu.be/5xkNy9gfKOg)

[РЕШЕНИЕ ПРОБЛЕМЫ ТИРИНГА В LINUX](https://youtu.be/4PLgKGPNusY)

[Peru 4K HDR 60FPS](https://youtu.be/1La4QzGeaaQ)

[Peru 8K](https://youtu.be/kEsb_RIWnak)

[vsync tearing test](https://youtu.be/9hIRq5HTh5s)

[Screen Tearing Test](https://youtu.be/MfL_JkcEFbE)

[Full HD LCD panel test, light bleeding test, motion test, tv tests](https://youtu.be/tPdLZ9g0l28)

[Dimming Test](https://youtu.be/3So8OFdqcdA)

[webgl aquarium](https://webglsamples.org/aquarium/aquarium.html)

[fishtank](https://webglsamples.org/fishtank/fishtank.html)

[blob](https://webglsamples.org/blob/blob.html)

[field](https://webglsamples.org/field/field.html)

[electricflower](https://webglsamples.org/electricflower/electricflower.html)

[dynamic cubemap](https://webglsamples.org/dynamic-cubemap/dynamic-cubemap.html)

[multiple views](https://webglsamples.org/multiple-views/multiple-views.html)

[spacerocks](https://webglsamples.org/spacerocks/spacerocks.html)

[electroShock](https://webglsamples.org/electroShock/application.html)

### А также есть очень полезный раздел [Intel tears out of the box](https://github.com/mpv-player/mpv/wiki/FAQ#x11intel) в mpv плеере

### Устанавливаем окружение по-умолчанию с OpenJDK8

```bash
sudo /usr/bin/archlinux-java get
```

```bash
sudo /usr/bin/archlinux-java set java-8-openjdk
```

```bash
sudo /usr/bin/archlinux-java status
```

### Настраиваем [русскую клавиатуру в Xorg](https://wiki.archlinux.org/index.php/Xorg/Keyboard_configuration) и вписываем в файл [/etc/X11/xorg.conf.d/00-keyboard.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/00-keyboard.conf) следующие данные

```bash
sudo vim /etc/X11/xorg.conf.d/00-keyboard.conf
```

```bash
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us,ru"
        Option "XkbModel" "pc105"
        Option "XkbVariant" "qwerty"
        Option "XkbOptions" "grp:lalt_lshift_toggle,grp_led:scroll"
EndSection
```

### Или что бы не вписывать можно скачать файл [/etc/X11/xorg.conf.d/00-keyboard.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/00-keyboard.conf)

```bash
sudo wget --https-only --output-document=/etc/X11/xorg.conf.d/00-keyboard.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/00-keyboard.conf
```

### Настраиваем прослушивание музыки через mpd и вписываем в файл [/etc/pulse/default.pa](https://raw.githubusercontent.com/akimdi/help-install-arch/master/default.pa) следующие данные

```bash
touch /home/me/.config/mpd/mpd.db /home/me/.config/mpd/state /home/me/.config/mpd/mpd.log /home/me/.config/mpd/mpd.pid
```

```bash
sudo vim /etc/pulse/default.pa
```

### Находим строку `load-module module-native-protocol-tcp` и изменяем её для прослушивания `127.0.0.1`

```bash
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
```

### Или что бы не вписывать можно скачать файл [/etc/pulse/default.pa](https://raw.githubusercontent.com/akimdi/help-install-arch/master/default.pa)

```bash
sudo wget --https-only --output-document=/etc/pulse/default.pa https://raw.githubusercontent.com/akimdi/help-install-arch/master/default.pa
```

### Установливаем zsh качестве оболочки по-умолчанию для root

```bash
sudo -i
```

```bash
sudo chsh -s /bin/zsh
```

```bash
exit
```

### Установка ZSH пользователю me

```bash
chsh -s /bin/zsh
```

### Настройка Git и GitHub

*Для начала создадим новый SSH ключ с кодовой фразой*

```bash
mkdir -p /home/me/.ssh
```

```bash
lsd -la /home/me/.ssh
```

```bash
ssh-keygen -o -a 100 -t ed25519 -f /home/me/.ssh/id_ed25519_home_pc_github_2021 -C "akimdi@users.noreply.github.com"
```

### Добавление SSH-ключа в ssh-agent

```bash
eval "$(ssh-agent -s)"
```

```bash
ssh-add /home/me/.ssh/id_ed25519_home_pc_github_2021
```

### Добавление нового ключа SSH в учетную запись GitHub

```bash
xclip -sel clip < /home/me/.ssh/id_ed25519_home_pc_github_2021.pub
```

*Заходим на страницу **[https://github.com/settings/keys](https://github.com/settings/keys)** и добавляем ключ из буфера обмена.*

*После добавления нового SSH-ключа в вашу учетную запись GitHub можно перенастроить любые локальные репозитории для использования SSH. Дополнительные сведения смотрите в разделе **[переключение удаленных URL-адресов с HTTPS на SSH.](https://help.github.com/articles/changing-a-remote-s-url/#switching-remote-urls-from-https-to-ssh)** Дальше следует протестировать SSH-соединение.*

### Тестирование SSH-соединения

```bash
ssh -T git@github.com
```

### Появится запрос ввода кодовой фразы и после неё установится соединение

```bash
Are you sure you want to continue connecting (yes/no)? yes

Hi akimdi! You've successfully authenticated,
but GitHub does not provide shell access.
```

### Повторить добавление ssh-ключа

```bash
ssh-add /home/me/.ssh/id_ed25519_home_pc_github_2021
```

### Настройка [chezmoi](https://github.com/twpayne/chezmoi)

*Это действие создаст chezmoi репозиторий в папке **```/home/me/.local/share/chezmoi```***

```bash
chezmoi -v init git@github.com:akimdi/archlinux-dotfiles.git
```
*Этой командой можно увидеть что будет изменено, прежде чем применить изменения*

```bash
chezmoi -v diff
```

*Эта команда проверит репозиторий и любые его подмодули и при необходимости создаст конфигурационный файл chezmoi и применит склонированный репозиторий в систему, то есть dotfiles которые будут в репозитории будут аналогичными и в системе*

```bash
chezmoi -v apply
```

*Последняя команда выполняет **```git pull```** из репозитория с dotfiles и одновременно применяет их в систему, то есть по сути команда **```chezmoi update```** это **```git pull```** **+** **```chezmoi apply```***

```bash
chezmoi -v update
```

*Добавляем клон репозитория на Gitlab и SourceHut*

```bash
cd /home/me/.local/share/chezmoi
```

```bash
git remote add origingitlab git@gitlab.com:akimdi/archlinux-dotfiles.git
```

```bash
git remote add originsourcehut git@git.sr.ht:~akimdi/archlinux-dotfiles
```

```bash
git remote -v
```

### Создаём папки для монтированных дисков и даём права

```bash
sudo mkdir -p /home/me/1tbVM /home/me/2tbnew /home/me/2tbold /home/me/4tb /home/me/6tb /home/me/10tb
```

```bash
sudo chown -R me:users /home/me/1tbVM
```

```bash
sudo chown -R me:users /home/me/2tbnew
```

```bash
sudo chown -R me:users /home/me/2tbold
```

```bash
sudo chown -R me:users /home/me/4tb
```

```bash
sudo chown -R me:users /home/me/6tb
```

```bash
sudo chown -R me:users /home/me/10tb
```

### Для автоматического монтирования дисков узнаем [UUID каждого из них](https://wiki.archlinux.org/index.php/Fstab)

```bash
lsblk -f
```

### Прописываем в файл [/etc/fstab](https://raw.githubusercontent.com/akimdi/help-install-arch/master/fstab) следующее содержимое

```bash
sudo vim /etc/fstab
```
### Вставляем UUID которые узнали с помощью команды выше (UUID могут меняться!!!)

```bash
# Static information about the filesystems.
# See fstab(5) for details.
#
# File /etc/fstab
#
# sudo lsblk -f
# sudo lsblk -no UUID
# sudo lsblk -no UUID /dev/sda1
# sudo blkid
#
# https://wiki.archlinux.org/index.php/Fstab
#
# <file system> <dir> <type> <options> <dump> <pass>

# /dev/sda3
UUID=2e5e677d-4a5e-4dc6-83bf-dde53741c51e	/         	ext4      	rw,relatime	0 1

# /dev/sda1
UUID=76D5-B099      	/boot     	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2

# /dev/sda2
UUID=841be320-b878-4e09-969c-3ab15a2dba21	none      	swap      	defaults  	0 0

tmpfs /home/me/ram tmpfs nodev,nosuid,size=32G 0 0

# /dev/sdb1
UUID=f89cab9f-0382-437a-a5c5-f6d64ca826f0	/home/me/1tbVM         	btrfs      	rw,relatime	0 1

# /dev/sdc1
UUID=f475ce11-b050-41d9-906f-6a7ae0e4d420	/home/me/10tb         	btrfs      	rw,relatime	0 1

# /dev/sdd1
UUID=da1cd0f0-b938-4355-b62e-1416acfad5b6	/home/me/6tb         	btrfs      	rw,relatime	0 1

# /dev/sde1
UUID=9cf10519-f747-40da-b7ce-5127eaa4f22c	/home/me/2tbnew         	btrfs      	rw,relatime	0 1

# /dev/sdf1
UUID=12832117-953c-4df0-af9a-3752e13d5a31	/home/me/2tbold         	btrfs      	rw,relatime	0 1

# /dev/sdg1
UUID=96433af1-6cb4-484f-9a60-11c1f0df1869	/home/me/4tb         	ext4      	rw,relatime,defaults,nofail    0  2
```

### Следует обязательно запустить [SpaceVim](https://github.com/SpaceVim/SpaceVim) после выполнения `fullupgrade` чтобы установились [необходимые](https://spacevim.org/use-vim-as-a-php-ide) [плагины](https://github.com/Gabirel/Hack-SpaceVim)

*SpaceVim интегрирован в систему обновления `fullupgrade`*

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

*Файл настроек SpaceVim лежит в **/home/me/.SpaceVim.d/init.toml***

```bash
vim
```

[Статьи по прокачке IDE SpaceVim](https://github.com/SpaceVim/SpaceVim/issues/3464)

[SpaceVim: A Vimmer’s Eval](https://medium.com/@JethroCao/spacevim-a-vimmers-eval-d2020118b517)

[Use faster file tree on SpaceVim](https://hashnode.com/post/use-faster-file-tree-on-spacevim-ck6djritm00jy3cs1l5zwk38s)

[SpaceVim: Layers Under-the-Hood](https://medium.com/swlh/spacevim-layers-under-the-hood-3dba2a02d13a)

[Installing and exploring SpaceVim](https://blog.wilcoxd.com/2017/01/09/installing-and-exploring-spacevim)

[My conclusion of using SpaceVim for 5 days](https://medium.com/@simonkistler/my-conclusion-of-using-spacevim-for-5-days-53c470c55748)

[Editor Almighty](https://medium.com/gdg-vit/editor-almighty-79807100f10c)

[What can you get from Hack-SpaceVim](https://github.com/Gabirel/Hack-SpaceVim)

### Устанавливаем [git-extras](https://github.com/tj/git-extras/blob/master/Installation.md#building-from-source) чтобы получить дополнительные [команды Git](https://github.com/tj/git-extras/blob/master/Commands.md)

```bash
sudo git clone --verbose https://github.com/tj/git-extras.git /home/me/ram/git-extras
```

```bash
cd /home/me/ram/git-extras
```

```bash
sudo git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
```

```bash
sudo make install
```

```bash
sudo wget --https-only --output-document=/usr/share/git/completion/git-extras-completion.zsh https://raw.githubusercontent.com/tj/git-extras/master/etc/git-extras-completion.zsh
```

```bash
cd /home/me/ram
```

```bash
sudo rm -r -f -v /home/me/ram/git-extras
```

### Перезагрузка

```bash
sudo shutdown -r 0
```

### Прописываем автозагрузку `mpd` от имени пользователя `me`

```bash
systemctl --user start mpd.service
```

```bash
systemctl --user enable mpd.service
```

```bash
systemctl --user status mpd.service
```

### Если хотим что бы музыка в плэйлисте [не останавливалась](https://www.linuxquestions.org/questions/linux-software-2/mpd-pauses-song-after-going-to-next-track-922664/#post6062662)

```bash
mpc single off
```

### Настраиваем [profile-sync-daemon](https://wiki.archlinux.org/index.php/Profile-sync-daemon)

```bash
sudo groupadd -f plugdev
```

```bash
sudo gpasswd -a me plugdev
```

```bash
psd p
```

```bash
psd
```

```bash
systemctl --user enable psd.service
```

```bash
systemctl --user start psd.service
```

```bash
systemctl --user status psd.service
```

### Настраиваем [Virtualbox](https://www.linuxtechi.com/install-virtualbox-on-arch-linux/)

```bash
sudo gpasswd -a me vboxusers
```

```bash
sudo gpasswd -a me vboxsf
```

```bash
sudo modprobe vboxdrv
```

```bash
sudo systemctl enable vboxweb.service
```

```bash
sudo systemctl start vboxweb.service
```

```bash
sudo systemctl status vboxweb.service
```

```bash
sudo lsmod | sudo grep -i vbox
```

### Настраиваем [nerd-fonts](https://github.com/ryanoasis/nerd-fonts)

```bash
wget --no-cache --no-cookies --https-only --show-progress --verbose --output-document=/home/me/ram/nerd-fonts.tar.gz https://github.com/ryanoasis/nerd-fonts/archive/refs/tags/v$(curl -Ls https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r ".tag_name" | sed -e "s/^.\{1\}//").tar.gz
```

```bash
tar -xvzf /home/me/ram/nerd-fonts.tar.gz -C /home/me/ram
```

```bash
cd /home/me/ram/nerd-fonts-*
```

```bash
./install.sh
```

```bash
cd
```

```bash
rm -r -f -v /home/me/ram/nerd-fonts.tar.gz
```

```bash
rm -r -f -v /home/me/ram/nerd-fonts-*
```

```bash
fc-list | ag terminess
```

```bash
fc-list | ag hack
```

```bash
fc-list | ag jet
```

*Шрифты установятся в папку **/home/me/.local/share/fonts/NerdFonts***

### Настраиваем [Vagrant](https://www.vagrantup.com)

```bash
mkdir -p /home/me/projects/vagrant /home/me/usbflash
```

```bash
mkdir -p /home/me/1tbVM/vagrant
```

```bash
vagrant plugin install vagrant-disksize vagrant-libvirt vagrant-digitalocean vagrant-netinfo vagrant-address vagrant-notify
```

```bash
vagrant plugin update
```

### Настройка отображения кодировки в текстовых редакторах

***gedit или xed открывает текстовые файлы в неправильной кодировке. Выполняем в терминале gconf-editor (запомните это приложение, оно полезное), идем в /apps/gedit-2/preferences/encodings.
Двойной клик по ключу auto-detected, поднимаем на самый верх пункт CURRENT.
Двойной клик по ключу shown-in-menu, поднимаем на самый верх пункты UTF-8 и WINDOWS-1251.
PS для Ubuntu 16.10 и Mint 17 нужно сделать так sudo apt-get install dconf-editor -y***

### Для редактора gedit

```bash
gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'WINDOWS-1251', 'KOI8-R', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
```

### Для редактора xed

```bash
gsettings set org.x.editor.preferences.encodings auto-detected "['UTF-8', 'WINDOWS-1251', 'KOI8-R', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
```

### Для редактора pluma

```bash
gsettings set org.mate.pluma auto-detected-encodings "['UTF-8', 'WINDOWS-1251', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
```

### Настройка [web-камеры](https://wiki.archlinux.org/index.php/Webcam_setup)

```bash
sudo ls -ltrh /dev/* | sa video
```

```bash
v4l2-ctl --list-devices
```

```bash
qv4l2
```

### Настройка [tor](https://wiki.archlinux.org/index.php/Tor)

```bash
sudo usermod -a -G tor me
```

```bash
sudo systemctl start tor.service
```

```bash
sudo systemctl enable tor.service
```

```bash
sudo systemctl status tor.service
```

*Например можно скачать видео которое недоступно в России или ограничено по IP*

```bash
torify youtube-dl --verbose https://www.***************.com/view_video.php?viewkey=********
```

```bash
proxychains youtube-dl --verbose https://www.***************.com/view_video.php?viewkey=********
```

### Настраиваем [экосистему](https://www.digitalocean.com/community/tutorials/docker-ru) [Docker](https://wiki.archlinux.org/index.php/Docker)

```bash
sudo systemctl start docker.service
```

```bash
sudo systemctl enable docker.service
```

```bash
sudo systemctl status docker.service
```

### Добавляем пользователя в группу docker

***Каждый пользователь в группе docker имеет [права](https://github.com/moby/moby/issues/9976), равноценные правам [суперпользователя](https://docs.docker.com/engine/security/security)***

```bash
sudo gpasswd -a me docker
```

### Настраиваем [драйвер](https://docs.docker.com/storage/storagedriver/select-storage-driver) хранения docker

*Отредактируйте файл **[/etc/docker/daemon.json](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file)** (создайте его, если он не существует), чтобы изменить драйвер хранения.*

```bash
sudo vim /etc/docker/daemon.json
```

```bash
{
  "storage-driver": "overlay2"
}
```

### Или что бы не вписывать можно скачать файл [/etc/docker/daemon.json](https://raw.githubusercontent.com/akimdi/help-install-arch/master/daemon.json)

```bash
sudo wget --https-only --output-document=/etc/docker/daemon.json https://raw.githubusercontent.com/akimdi/help-install-arch/master/daemon.json
```

*Есть так же [Rootless mode](https://docs.docker.com/engine/security/rootless) который позволяет запускать контейнеры без root, но у него есть некоторые ограничения и не рекомендуется использовать на сервере в production среде*

*А также есть всеми любимый список [Awesome Docker](https://github.com/veggiemonk/awesome-docker)*

### Устанавливаем [usql](https://github.com/xo/usql)

*Universal command-line interface for SQL databases*

```bash
go get -u -v github.com/xo/usql
```

### Устанавливаем [hf](https://github.com/hugows/hf)

*Fuzzy file finder for the command line*

```bash
go get -u -v github.com/hugows/hf
```

### Перезагружаемся

```bash
sudo shutdown -r 0
```

### Настройка [Dunst](https://wiki.archlinux.org/index.php/Dunst)

### Ставим расширения для [Firefox](https://www.reddit.com/r/firefox/comments/84u8ib/complete_guide_to_disable_all_firefox_ui)

```bash
about:config
```

```bash
toolkit.cosmeticAnimations.enabled = false
```

```bash
toolkit.scrollbox.smoothScroll = false
```

```bash
browser.tabs.warnOnClose = false	
```

```bash
browser.tabs.warnOnCloseOtherTabs = false
```

```bash
network.trr.mode = 3
```

```bash
network.trr.uri = https://cloudflare-dns.com/dns-query
```

```bash
image.avif.enabled = true
```

```bash
network.dns.echconfig.enabled = true
```

```bash
network.dns.use_https_rr_as_altsvc = true
```

```bash
gfx.webrender.all = true
```

```bash
gfx.webrender.enabled = true
```

***Полезные ссылки***

[Проверка на DoH и Encrypted SNI (ECH)](https://www.cloudflare.com/ssl/encrypted-sni)

[Включение ECH для скрытия домена в HTTPS-трафике в Firefox by Opennet](https://www.opennet.ru/opennews/art.shtml?num=54384)

[Включение DNS over HTTPS в Firefox by Opennet](https://www.opennet.ru/tips/3086_esni_doh_dns_https.shtml)

***Полезные дополнения (обязательные)***

[Theme GruvBox Dark](https://addons.mozilla.org/firefox/addon/gruvbox-dark)

[Adguard](https://addons.mozilla.org/firefox/addon/adguard-adblocker)

[CanvasBlocker](https://addons.mozilla.org/firefox/addon/canvasblocker)

[CanvasBlocker settings](https://raw.githubusercontent.com/akimdi/help-install-arch/main/CanvasBlocker-settings_2021-02-26_01-12-22.json)

[Clear Browsing Data](https://addons.mozilla.org/firefox/addon/clear-browsing-data)

[YouTube NonStop](https://addons.mozilla.org/firefox/addon/youtube-nonstop)

[YouTube High Definition](https://addons.mozilla.org/firefox/addon/youtube-high-definition)

[SponsorBlock](https://addons.mozilla.org/firefox/addon/sponsorblock)

[ClearURLs](https://addons.mozilla.org/firefox/addon/clearurls)

[Close All Tabs](https://addons.mozilla.org/firefox/addon/close-all-tabs-webextension)

[cookies](https://addons.mozilla.org/firefox/addon/cookies-txt)

[Copy PlainText](https://addons.mozilla.org/firefox/addon/copy-plaintext)

[Decentraleyes](https://addons.mozilla.org/firefox/addon/decentraleyes)

[Firefox Multi-Account Containers](https://addons.mozilla.org/firefox/addon/multi-account-containers)

[FoxyProxy Standard](https://addons.mozilla.org/firefox/addon/foxyproxy-standard)

[FoxyProxy Standard setting](https://raw.githubusercontent.com/akimdi/help-install-arch/main/FoxyProxy%20Standard_2021-02-25.json)

[LanguageTool](https://addons.mozilla.org/firefox/addon/languagetool)

[Grammarly](https://addons.mozilla.org/firefox/addon/grammarly-1)

[HTTPS Everywhere](https://addons.mozilla.org/firefox/addon/https-everywhere)

[Incognito This Tab](https://addons.mozilla.org/firefox/addon/incognito-this-tab)

[KeePassXC-Browser](https://addons.mozilla.org/firefox/addon/keepassxc-browser)

[Merge Windows](https://addons.mozilla.org/firefox/addon/merge-window)

[NoScript Security Suite](https://addons.mozilla.org/firefox/addon/noscript)

[Ping Blocker](https://addons.mozilla.org/firefox/addon/ping-blocker)

[Privacy Badger](https://addons.mozilla.org/firefox/addon/privacy-badger17)

[Privacy Possum](https://addons.mozilla.org/firefox/addon/privacy-possum)

[Search by Image](https://addons.mozilla.org/firefox/addon/search_by_image)

[Search on Google US](https://addons.mozilla.org/firefox/addon/search-google-us)

[Temporary Containers](https://addons.mozilla.org/firefox/addon/temporary-containers)

[Temporary Containers setting](https://raw.githubusercontent.com/akimdi/help-install-arch/main/temporary_containers_preferences_2021-02-26_01.43.25.json)

[uMatrix](https://addons.mozilla.org/firefox/addon/umatrix)

[uMatrix setting](https://raw.githubusercontent.com/akimdi/help-install-arch/master/my-umatrix-backup.txt)

[mailvelope](https://addons.mozilla.org/firefox/addon/mailvelope)

[tridactyl-vim](https://addons.mozilla.org/firefox/addon/tridactyl-vim)

***Полезные дополнения (необязательные)***

[firefox relay](https://addons.mozilla.org/firefox/addon/private-relay)

[Stylus](https://addons.mozilla.org/firefox/addon/styl-us)

[Dark GitHub style](https://github.com/StylishThemes/GitHub-Dark)

[Pinned header on GitHub](https://github.com/StylishThemes/GitHub-FixedHeader)

[Tabby - Window & Tab Manager](https://addons.mozilla.org/firefox/addon/tabby-window-tab-manager)

[Violentmonkey](https://addons.mozilla.org/firefox/addon/violentmonkey)
