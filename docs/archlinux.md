# 🐧 Установка [Arch Linux](https://www.archlinux.org/download) с нуля

### Скачиваем образ, хэш-сумму и подпись

```bash
wget --https-only https://mirrors.evowise.com/archlinux/iso/latest/sha1sums.txt https://mirrors.evowise.com/archlinux/iso/latest/md5sums.txt https://www.archlinux.org/iso/$(date +"%Y").$(date +"%m").01/archlinux-$(date +"%Y").$(date +"%m").01-x86_64.iso.sig https://mirrors.evowise.com/archlinux/iso/latest/archlinux-$(date +"%Y").$(date +"%m").01-x86_64.iso
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
sha1sum --ignore-missing -c sha1sums.txt && md5sum --ignore-missing -c md5sums.txt
```

***Записываем на флэшку с помощью [Rufus](https://github.com/pbatard/rufus/releases/latest) или [Etcher](https://github.com/balena-io/etcher/releases/latest)***

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
pacstrap /mnt base base-devel linux linux-firmware dhcp dhcpcd dhcping dhclient networkmanager inetutils netctl coreutils binutils wget curl vim nano zsh htop git openssh intel-ucode
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

### Включите en_US.UTF-8 UTF-8 и ru_RU.UTF-8 UTF-8 локали, раскомментировав их в файле /etc/locale.gen, после чего сгенерируйте их:

```bash
vim /etc/locale.gen
```

```bash
locale-gen
```

### Создайте файл locale.conf и задайте необходимое значение в нем для переменной LANG:

```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### Настройка сети. Создаём файл hostname

```bash
echo "book" > /etc/hostname
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
pacman -S grub efibootmgr
```

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

```bash
pacman -S os-prober
```

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### Дальше мы выходим из chroot и перезагружаем машину

```bash
exit
```

```bash
sudo shutdown -r 0
```

*После перезагрузки входим из под пользователя **root** *

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
sudo pacman -Syyu
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

# На этом минимальная настройка завершена. Дальше пойдет инструкция по установки дополнительного программного обеспечения, шрифтов, а также WM.

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
sudo printf "tmpfs /home/me/ram tmpfs nodev,nosuid,size=16G 0 0" >> /etc/fstab
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

### Самое главное чтобы раскомментировать строки относящиеся к репозиториям extra community multilib

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

### Устанавливаем необходимые пакеты из [списка](https://superuser.com/q/1061612) в [файле](https://wiki.archlinux.org/index.php/Pacman/Tips_and_tricks)

```bash
sudo wget -O /home/me/ram/pkglist.txt https://raw.githubusercontent.com/akimdi/help-install-arch/master/pkglist.txt
```

```bash
sudo pacman -S --needed --noconfirm - < /home/me/ram/pkglist.txt
```

```bash
sudo rm -v /home/me/ram/pkglist.txt
```

### Или можно установить эти пакеты из командной строки

```bash
sudo pacman -S --needed --noconfirm inetutils sudo base base-devel linux netctl coreutils binutils dhcp dhclient dhcping fd mlocate dwdiff wdiff the_silver_searcher ripgrep ack fzf fzy percol tar less most mc findutils diffutils grep sed gawk util-linux procps-ng psmisc cmake make shadow gcc lld lldb jdk11-openjdk openjdk11-doc openjdk11-src visualvm doxygen doxygen-docs fastjar freemind swt mill kitty alacritty alacritty-terminfo rxvt-unicode xterm abduco dvtm screen tmux trash-cli nnn fff ranger vifm nautilus nemo thunar rclone p7zip zip rsync grsync file-roller colordiff diffuse kdiff3 kompare meld gprename krename perl-rename gnome-search-tool catfish kfind mate-utils regexxer exa lsd tree bat cpio libarchive nawk htop recoll git hub gnome-builder kdevelop lazarus lazarus-qt5 fpc fpc-src netbeans unzip eclipse-php eclipse-common massif-visualizer nemiver scanmem gameconqueror sysprof flex byacc bison peg ragel kde-dev-utils phonon-qt5-gstreamer phonon-qt5 pulseaudio glade fltk ghex okteta jshon jq yq umbrello devhelp zeal kcharselect gucharmap gnome-characters parted gnome-disk-utility gparted partitionmanager btrfs-progs dosfstools exfat-utils f2fs-tools xdg-desktop-portal-gtk e2fsprogs jfsutils nilfs-utils ntfs-3g udftools reiserfsprogs xfsprogs ecryptfs-utils unionfs-fuse clonezilla deepin-clone fsarchiver partclone partimage udevil udiskie kdf filelight baobab ncdu gdmap testdisk foremost extundelete ext4magic gsmartcontrol libatasmart sweeper rmlint-shredder rmlint fdupes bleachbit gnome-multi-writer gnome-system-monitor xfce4-taskmanager mate-system-monitor lxtask ksysguard gnome-usage psensor xsensors conky conky-manager usbview kinfocenter lshw hardinfo nmon screenfetch neofetch hwinfo hwdetect dmidecode archey3 pacmanlogviewer ksystemlog gnome-system-log gnome-logs xorg-xman khelpcenter yelp gwaterfall gnome-font-viewer kcron cronie ktimer kshutdown chrony light gnome-color-manager displaycal argyllcms redshift sxhkd xsel cups-pdf cups bluez-cups system-config-printer print-manager blueman blueberry bluedevil gnome-bluetooth bluez-utils acpid acpi powertop tlp tlp-rdw lostfiles firefox firefox-developer-edition chromium opera upower wire-desktop wireless_tools wireshark-cli wireshark-qt kismet wifite wpa_supplicant cowpatty abook pacmatic pkgfile aria2 uget curl wget reflector pcurses ca-certificates ca-certificates-mozilla tor stow openssl xclip xorg-xclipboard pluma iotop net-tools linux-headers rofi vim kbd terminus-font adobe-source-code-pro-fonts awesome-terminal-fonts ttf-dejavu ttf-liberation dosbox metasploit telegram-desktop libreoffice-fresh libreoffice-fresh-ru libreoffice-extension-texmaths libreoffice-extension-writer2latex lyx mythes kleopatra ncrack gimp gimp-help-ru gimp-nufraw gimp-plugin-fblur gimp-plugin-gmic gimp-plugin-lqr gimp-plugin-wavelet-denoise gimp-refocus pinta potrace pdfmixtool ffmpeg ffmpeg2theora qtav opera-ffmpeg-codecs ffmpegthumbs ffmpegthumbnailer gnome-video-effects pdfmod mupdf mupdf-tools paperwork pdf2djvu pdf2svg pdfcrack pdfsam pdftricks qpdf qpdfview wkhtmltopdf xpdf diffpdf zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps epdfview evince gscan2pdf gv img2pdf mpv cgit git-annex git-crypt gitg git-latexdiff gitolite gitprompt-rs git-repair hub tig qgit krita pulseeffects chezmoi kate ark adwaita-icon-theme git-annex fakeroot qmmp okular links youtube-dl imagemagick aws-cli pandoc pandoc-citeproc cgrep mkvtoolnix-gui mkvtoolnix-cli rust rust-docs rust-bindgen rust-racer gedit gedit-plugins autossh openssh zsh zsh-doc zsh-lovers libvirt libvirt-glib libvirt-python perl-sys-virt dkms polkit virt-manager virt-install qemu qemu-arch-extra qemu-block-gluster qemu-block-iscsi qemu-block-rbd qemu-guest-agent unicorn android-tools android-file-transfer android-udev ttf-droid speedtest-cli cmatrix openshot sox mps-youtube zim smplayer smplayer-skins smplayer-themes optipng hicolor-icon-theme arc-icon-theme audacious audacious-plugins flac i7z gnome-icon-theme gnome-icon-theme-extras gnome-icon-theme-symbolic ttf-fira-sans ttf-fira-mono ttf-ionicons ttf-font-awesome perl-json-xs pass pass-otp rofi-pass pwgen qtpass xournalpp crash pgpdump tcpdump tcptrace xfsdump xorg-xpr scrot connman networkmanager wifi-radar openvpn pptpclient wireguard-tools shadowsocks shadowsocks-qt5 stunnel elinks lynx w3m falkon qutebrowser min vimb midori axel you-get youtube-viewer mps-youtube nextcloud-client filezilla rtorrent gist pastebinit neomutt mutt nftables fractal riot-desktop riot-web wavpack a52dec celt libmad lame vlc obs-studio kdenlive gaupol cmus opus libvorbis opencore-amr speex faac faad2 libfdk-aac jasper openjpeg aom dav1d schroedinger libdv x265 libde265 x264 libmpeg2 libtheora libvpx ogmtools remmina toxcore toxic qtox eom eog feh geeqie gwenview fbida renameutils nomacs qiv sxiv viewnior vimiv gnome-photos digikam python-cairosvg converseen graphicsmagick gmic guetzli xloadimage jpegoptim optipng pinta fbida fbv darktable flameshot gnome-screenshot maim gpick kcolorchooser gcolor3 gcolor2 sweethome3d fontforge calligra calligra-plan inkscape gnome-calculator speedcrunch dia rawtherapee moc mpg123 xmms2 beets soundconverter audacity gnome-sound-recorder sweep kwave alsa-utils qastools gnac ecasound picard quodlibet easytag mp3unicode mp3info id3v2 mplayer gst-plugins-base-libs minitube smtube gnome-mplayer transmageddon handbrake handbrake-cli ciano transcode mencoder avidemux-cli avidemux-qt subtitleeditor gaupol gnome-subtitles aegisub subdownloader subdl shotcut pitivi blender simplescreenrecorder recordmydesktop peek deepin-screen-recorder byzanz zart v4l-utils motion kamoso cheese perl-image-exiftool exiv2 jhead mediainfo mediainfo-gui libsndfile android-file-transfer gnokii gnome-phone-manager kdeconnect gammu wammu acetoneiso2 brasero k3b libdvdread libdvdcss libdvdnav deepin-system-monitor gnome-maps gnome-documents gnome-calendar gnome-terminal simple-scan cool-retro-term tilix sparkleshare syncthing syncthing-gtk codeblocks libatasmart glabels scribus abiword vis kakoune kak-lsp xed leafpad beaver atom nano joe e3 gnumeric libgda kexi txt2tags asciidoc asciidoctor ascii asciinema asciiquarium banner txt2man vbindiff container-diff diff-so-fancy xdelta3 containerd vagrant packer libvirt virt-viewer gnome-boxes cpupower minikube kubectl k9s kubectx pinfo texmaker gnome-latex minted gummi qtikz ktikz auto-multiple-choice dblatex dot2tex git-latexdiff hevea kile latex2html latex2rtf otf-latin-modern otf-latinmodern-math python-docutils python-latexcodec rubber sagetex texlive-bin texlive-langchinese texlive-langcyrillic texlive-langextra texlive-langgreek texlive-langjapanese texlive-langkorean texlive-bibtexextra texlive-core texlive-fontsextra texlive-formatsextra texlive-games texlive-humanities texlive-latexextra texlive-music texlive-pictures texlive-pstricks texlive-publishers texlive-science texstudio gnome-chess supertux supertuxkart josm calc khal remind when gnome-clocks armagetronad arc-gtk-theme intellij-idea-community-edition qmapshack desktop-file-utils gpicview kuickshow gnome-todo noto-fonts-extra hostapd jad jadx groovy ant java11-openjfx java11-openjfx-src java11-openjfx-doc java-avalon-framework java-bcel java-sqlite-jdbc jruby kotlin gradle jython maven scala xalan-java xerces2-java acme-tiny monit git-lfs git-review lolcat gnome-tweaks datamash clusterssh archlinux-wallpaper wallutils imlib2 strace svt-av1 gc dos2unix pango unrar ack newsboat swig mpop entr gyp sshfs duplicity bash wpscan unoconv ghi libtorrent xz ncurses source-highlight dbeaver dbeaver-plugin-apache-poi dbeaver-plugin-batik dbeaver-plugin-bouncycastle dbeaver-plugin-office dbeaver-plugin-sshj dbeaver-plugin-sshj-lib dbeaver-plugin-svg-format httpie calibre displaycal gnome-control-center vegeta whois lximage-qt parallel shellcheck faba-icon-theme adapta-gtk-theme compsize grub-btrfs snap-pac snapper acl snap-sync syslinux haskell-doctemplates haskell-pandoc-types pandoc-crossref python-pypandoc python-pandocfilters clang llvm openmp compiler-rt badtouch arch-audit hexyl skim sd vivid watchexec smali dgen-sdl gens-gs yabause-qt yelp-tools yasm cuneiform python-pyocr archivetools archlinux-keyring asp which vi autoconf automake groff gzip libtool m4 pacman patch pkgconf systemd texinfo bzip2 cryptsetup popt device-mapper argon2 dhcpcd file filesystem gcc-libs gettext iproute2 iputils licenses linux-firmware logrotate lvm2 man-db man-pages mdadm pciutils perl s-nail sysfsutils systemd-sysvcompat usbutils glibc javasqlite java-rxtx java-runtime-common retext setconf bbe bluefish canorus dconf-editor ed jedit kid3-qt l3afpad mousepad snd translate-shell hedgewars clipgrab lollypop atomicparsley aspell aspell-ca aspell-cs aspell-de aspell-el aspell-en aspell-es aspell-fr aspell-hu aspell-it aspell-nb aspell-nl aspell-nn aspell-pl aspell-pt aspell-ru aspell-sv aspell-uk linux-tools bpf cgroup_event_listener hyperv libtraceevent perf tmon turbostat usbip x86_energy_perf_policy ltris xreader almanah texlive-most texlive-lang drawing ncmpcpp ncmpc linssid tuxcmd diffoscope cantata ario mpc xfmpc htmldoc veracrypt wgetpaste xorg-apps xorg-bdftopcf xorg-iceauth xorg-luit xorg-mkfontscale xorg-sessreg xorg-setxkbmap xorg-smproxy xorg-x11perf xorg-xauth xorg-xbacklight xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma xorg-xhost xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwd xorg-xwininfo xorg-xwud xorg-fonts xorg-fonts-encodings xorg-font-util mesa-demos fio hyperfine netperf siege sysbench bonnie++ hdparm iperf iperf3 libdca libmpcdec libwebp fdkaac xvidcore xine-lib xine-ui gst-libav intel-ucode iucode-tool pv dcfldd ddrescue gmock noto-fonts ttf-croscore noto-fonts-cjk noto-fonts-emoji ttf-caladea ttf-carlito ttf-opensans ttf-roboto yubioath-desktop kstars moserial rox screengrab utox rawdog zstd gnome-autoar expat zshdb readline paxtest lynis arch-wiki-docs ngrep llpp gst-plugins-bad gst-plugins-good gst-plugins-ugly intel-gmmlib dehydrated hydra exploitdb pixiewps bettercap bettercap-caplets hashcat hashcat-utils cifs-utils iw aircrack-ng fcrackzip john ophcrack pyrit findmyhash cracklib nmap vulscan fping ghostpcl ghostscript ghostxps borgmatic borg hddtemp whowatch libvdpau libvdpau-va-gl libva-intel-driver mesa adriconf xf86-video-nouveau vulkan-intel xf86-input-evdev xf86-input-libinput xf86-input-synaptics xf86-input-void lib32-virtualgl lib32-primus libva-mesa-driver mesa-vdpau libva-vdpau-driver libva-utils vdpauinfo vim-latexsuite sslstrip sslsplit sslscan sqlmap nikto mitmproxy masscan swaks tcpreplay netbrake hashdeep ifenslave minicom picocom tinyserial lftp evilginx dnscrypt-proxy dns-over-https jnettop arp-scan rink ctags mtr traceroute mkinitcpio linuxconsole vapoursynth nemo-seahorse seahorse seahorse-nautilus nvchecker mftrace ttf-cascadia-code ttf-cormorant ttf-fantasque-sans-mono ttf-fira-code ttf-inconsolata ttf-proggy-clean ttf-roboto-mono ttf-ubuntu-font-family progress fvextra iso-codes terraform terraform-provider-keycloak eric docker-machine docker-compose docker syntax-highlighting nano-syntax-highlighting python-qrcode nfs-utils firewalld ebtables dnsmasq tinyemu dosemu multitail bomber asciiportal namcap expac naev astromenace babeltrace dnstracer extremetuxracer grc imwheel xorg-appres xorg-docs xorg-fonts-100dpi xorg-fonts-75dpi xorg-fonts-alias xorg-fonts-cyrillic xorg-fonts-misc xorg-fonts-type1 xorg-font-utils xorg-oclock xorg-server xorg-server-common xorg-server-devel xorg-server-xephyr xorg-server-xnest xorg-server-xvfb xorg-twm xorg-util-macros xorg-xbiff xorg-xcalc xorg-xclock xorg-xconsole xdm-archlinux xorg-xdm autorandr xorg-xedit xorg-xeyes xorg-xfd xorg-xfontsel xorg-xinit xorg-xload xorg-xlogo xorg-xlsfonts xorg-xmag xorg-xmessage xorg-xvidtune i3-gaps py3status i3blocks i3lock-color conky dmenu rofi perl-anyevent-i3 albert rng-tools nyx sigal qbittorrent sssd trojan mailcap zbar zbar-qt detox qrencode qreator sysstat kcptun rsnapshot ext3grep docx2txt lrzip pdftk pdfgrep duperemove snappy lz4 lzip xarchiver lzop atool arj par2cmdline sharutils brotli zlib unarchiver djvulibre tesseract gimagereader-qt gimagereader-common quiterss tesseract-data tesseract-data-tha tesseract-data-tir tesseract-data-tur tesseract-data-uig tesseract-data-ukr tesseract-data-urd tesseract-data-uzb tesseract-data-uzb_cyrl tesseract-data-vie tesseract-data-yid tesseract-data-lat tesseract-data-lav tesseract-data-lit tesseract-data-mal tesseract-data-mar tesseract-data-mkd tesseract-data-mlt tesseract-data-msa tesseract-data-mya tesseract-data-nep tesseract-data-nld tesseract-data-nor tesseract-data-ori tesseract-data-pan tesseract-data-pol tesseract-data-por tesseract-data-pus tesseract-data-ron tesseract-data-rus tesseract-data-san tesseract-data-sin tesseract-data-slk tesseract-data-slk_frak tesseract-data-slv tesseract-data-spa tesseract-data-spa_old tesseract-data-sqi tesseract-data-srp tesseract-data-srp_latn tesseract-data-swa tesseract-data-swe tesseract-data-syr tesseract-data-tam tesseract-data-tel tesseract-data-tgk tesseract-data-tgl tesseract-data-afr tesseract-data-amh tesseract-data-ara tesseract-data-asm tesseract-data-aze tesseract-data-aze_cyrl tesseract-data-bel tesseract-data-ben tesseract-data-bod tesseract-data-bos tesseract-data-bul tesseract-data-cat tesseract-data-ceb tesseract-data-ces tesseract-data-chi_sim tesseract-data-chi_tra tesseract-data-chr tesseract-data-cym tesseract-data-dan tesseract-data-dan_frak tesseract-data-deu tesseract-data-deu_frak tesseract-data-dzo tesseract-data-ell tesseract-data-eng tesseract-data-enm tesseract-data-epo tesseract-data-equ tesseract-data-est tesseract-data-eus tesseract-data-fas tesseract-data-fin tesseract-data-fra tesseract-data-frk tesseract-data-frm tesseract-data-gle tesseract-data-glg tesseract-data-grc tesseract-data-guj tesseract-data-hat tesseract-data-heb tesseract-data-hin tesseract-data-hrv tesseract-data-hun tesseract-data-iku tesseract-data-ind tesseract-data-isl tesseract-data-ita tesseract-data-ita_old tesseract-data-jav tesseract-data-jpn tesseract-data-kan tesseract-data-kat tesseract-data-kat_old tesseract-data-kaz tesseract-data-khm tesseract-data-kir tesseract-data-kor tesseract-data-kur tesseract-data-lao cppcheck check rstcheck aide rkhunter enchant ipguard libpcap arpwatch bully darkstat dsniff etherape ettercap pth net-snmp iftop hcxtools hping lorcon p0f zmap libsrtp languagetool reprotest disorderfs yapf splint afew alot notmuch notmuch-mutt notmuch-runtime notmuch-vim sylpheed m2r pelican python-pybtex-docutils python-recommonmark python-cloudflare certbot-dns-google certbot-dns-digitalocean certbot-dns-ovh certbot-nginx certbot acme.sh certbot-dns-cloudflare hcloud minio s3cmd s3fs-fuse abcde arduino arduino-avr-core arduino-builder arduino-cli arduino-ctags arduino-docs reaver slowhttptest thc-ipv6 mcabber testssl.sh xca bsd-games cadaver castget dateutils fasd gifsicle hopenpgp-tools mailutils lxsplit mednafen mdp mktorrent mp3splt pamixer pngquant skopeo snarf task vit timew tldr unrtf watchman wavegain yad afl atril cpuburn jpegexiforient libexif python-piexif urlwatch abuse aisleriot blobwars blobwars-data bzflag cuyo tuxcards ksnakeduel ksirk lincity-ng ufw ufw-extras iptstate frozen-bubble pathological gnuchess xboard usleep ktorrent pan photoflare rssguard synbak shotgun spectacle fbgrab arptables ferm ipset bridge-utils openbsd-netcat packeth zaproxy nitrogen acpi_call glu lib32-mesa fbset prettyping lesspipe colorgcc expect ccze xbindkeys xdotool xautomation navit merkaartor stellarium xxkb evtest xcape otf-fantasque-sans-mono croc uncrustify elisa macchanger horst wavemon tzdata ppp ndisc6 syslog-ng gnome-nettool debian-archive-keyring minizip keyutils gnupg gpa gpg-crypter kgpg ubuntu-keyring gpm badvpn chntpw beep echoping httping ioping quilt scrapy smokeping vym wipe xkbsel julius medusa otter-browser otf-overpass hcxkeys pinentry posterazor ncompress gperftools heaptrack otf-fira-mono otf-fira-sans uchardet oprofile qcachegrind remake rofimoji pacman-contrib pacman-mirrorlist chromium-bsu pydf nss clojure graphviz xmldiff pkgdiff pygmentize python-pygments s-tui sonic-visualiser bar barcode zint zint-qt gnome-music nyancat supervisor bochs create_ap ipmitool iptraf-ng ipv6calc ipvsadm pigz pstotext psutils teeworlds munin urlscan go go-tools asunder goobox whipper lire nethack glhack osquery xapps imvirt cantor kalgebra libqalculate qalculate-gtk baloo keepassxc kwallet rdesktop gopass firetools firejail pngquant atop xtrabackup findomain sn0int pppusage modemmanager variety dunst consul consul-template mysql-workbench mariadb mariadb-clients mariadb-libs mytop innotop samba spice spice-gtk spice-protocol spice-vdagent avfs
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
127.0.1.1 book.localdomain book
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

### В самом конце файла должны написать пару строк

```bash
vim /home/me/.xinitrc
```

```bash
/usr/bin/VBoxClient-all
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

### Установливаем zsh качестве оболочки по-умолчанию для root

```bash
sudo -i
```

```bash
sudo chsh -s /bin/zsh
```

### Установка ZSH пользователю me

```bash
sudo usermod me -s /usr/bin/zsh
```

### Установка [Antigen](https://github.com/zsh-users/antigen)

```bash
sudo wget --https-only --output-document=/home/me/antigen.zsh https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh
```

### Установка [Git-Extras](https://github.com/tj/git-extras)
```bash
sudo wget --https-only --output-document=/usr/share/git/completion/git-extras-completion.zsh https://raw.githubusercontent.com/tj/git-extras/master/etc/git-extras-completion.zsh
```

### Установка [ripgrep-all](https://github.com/phiresky/ripgrep-all)

```bash
cargo install ripgrep_all
```

### Настройка Git и GitHub

*Для начала создадим новый SSH ключ с кодовой фразой*

```bash
mkdir -p /home/me/.ssh
```

```bash
lsd -la /home/me/.ssh
```

*Для Github нужно создавать обязательно с комментарием в виде почты, как показано на примере ниже. После флага -С следует подставить свою почту на Github. Важно не перепутать её с обычной почтой!*

```bash
ssh-keygen -o -a 100 -t ed25519 -f /home/me/.ssh/id_ed25519_home_notebook_github_2020 -C "akimdi@users.noreply.github.com"
```

### Добавление SSH-ключа в ssh-agent

```bash
eval "$(ssh-agent -s)"
```

```bash
ssh-add /home/me/.ssh/id_ed25519_home_notebook_github_2020
```

### Добавление нового ключа SSH в учетную запись GitHub

```bash
xclip -sel clip < /home/me/.ssh/id_ed25519_home_notebook_github_2020.pub
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

Hi! You've successfully authenticated,
but GitHub does not provide shell access.
```

### Повторить добавление ssh-ключа

```bash
ssh-add /home/me/.ssh/id_ed25519_home_notebook_github_2020
```

### Установка [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

```bash
git clone --verbose https://github.com/ryanoasis/nerd-fonts.git /home/me/ram/nerd
```

```bash
chmod +x /home/me/ram/nerd/install.sh
```

```bash
/home/me/ram/nerd/install.sh
```

```bash
fc-list | ag terminess
```

```bash
fc-list | ag hack
```

*Шрифты установятся в папку **/home/me/.local/share/fonts/NerdFonts***

### Установка [SpaceVim](https://github.com/SpaceVim/SpaceVim)

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

### Следует обязательно запустить SpaceVim чтобы установились [необходимые](https://spacevim.org/use-vim-as-a-php-ide) [плагины](https://github.com/Gabirel/Hack-SpaceVim)

```bash
vim
```

*Файл настроек SpaceVim лежит в **/home/me/.SpaceVim.d/init.toml***

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

### Настройка отображения кодировки в текстовых редакторах

***gedit или xed открывает текстовые файлы в неправильной кодировке. Выполняем в терминале gconf-editor (запомните это приложение, оно полезное), идем в /apps/gedit-2/preferences/encodings.
Двойной клик по ключу auto-detected, поднимаем на самый верх пункт CURRENT.
Двойной клик по ключу shown-in-menu, поднимаем на самый верх пункты UTF-8 и WINDOWS-1251.
P.S. для Ubuntu и Mint нужно сделать через sudo apt-get install dconf-editor -y***

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

### Настраиваем [i3lock-fancy](https://github.com/meskarune/i3lock-fancy)

```bash
sudo git clone --verbose https://github.com/meskarune/i3lock-fancy.git /home/me/ram/i3lock-fancy
```
```bash
cd /home/me/ram/i3lock-fancy
```

```bash
sudo make install
```

```bash
sudo shutdown -r 0
```

### Настраиваем виртуальную машину через [QEMU](https://wiki.archlinux.org/index.php/QEMU) и [libvirt](https://wiki.archlinux.org/index.php/Libvirt)

### Создание [образа гостевой системы](https://www.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.ldva/ldva_r_qemu-imgCommand.html)

```bash
qemu-img create -f qcow2 debian-deploy.qcow2 128G
```

*-f указывает на формат файла, лучше использовать формат qcow2 родной для QEMU, так как qcow2 формат записи образа виртуальных машины с поддержкой сжатия, снапшотов и шифрования. Кроме того qcow2 образ занимает столько места, сколько данных записано в него виртуальной машиной, вне зависимости от размера созданного изначально при создании.*

*debian-deploy.qcow2 это имя нашего файла образа.*

*128G это размер файла для образа, в данном примере 128 гигабайт.*


### После выполнения данной команды будет такое сообщение

```bash
Formatting 'debian-deploy.qcow2', fmt=qcow2 size=8589934592 encryption=off cluster_size=65536 lazy_refcounts=off
```

### Установка ISO образа в QEMU

*Сначала нам надо запустить ISO образ в QEMU, затем проинсталлировать и потом уже использовать полученную виртуальную систему.*

```bash
qemu-system-x86_64 -cpu IvyBridge -enable-kvm -hda debian-deploy.qcow2 -cdrom /home/me/projects/vm/debian-deploy/debian-10.2.0-amd64-netinst.iso -boot d -m 4096
```
*-cpu IvyBridge это опция отвечающая за эмуляцию командных инструкций процессоров под кодовым названием IvyBridge. В принципе вы можете узнать какие еще процессора поддерживает qemu и выбрать свой.*

*-enable-kvm = включаем поддержку kvm ядра. Если мы не включим эту опцию, то qemu будет запущен без использования kvm.*

*-hda debian-deploy.qcow2 это указываем какой файл образ будем использовать. Выше было описано, как его создавать.*

*-cdrom /home/me/projects/vm/debian-deploy/debian-10.2.0-amd64-netinst.iso это опция указывает, что мы будем использовать ISO образ который находится виртуально на устройстве cdrom.*

*-boot d это указывает, что грузиться qemu будет с cdrom (т.е. с нашего ISO образа) но буква d говорит о том, что ISO образ находится не в приводе cdrom, а на жестком диске.*

*-m 4096 это указывает, сколько памяти будет выделено под работу qemu. В данном примере 4 Гигабайта.*

### Запуск виртуальной ОС в QEMU

```bash
qemu-system-x86_64 -cpu IvyBridge -enable-kvm -hda debian-deploy.qcow2 -m 4096
```

*Отличие данной строки запуска, от строки запуска с ISO образом в том, что в первом случае мы указываем параметр: -cdrom /home/me/projects/vm/debian-deploy/debian-10.2.0-amd64-netinst.iso и -boot d. Здесь, же нам это не требуется, т.к. уже имеется файл с установленной виртуальной системой.*

### Просмотр информации об образе системы

```bash
qemu-img info debian-deploy.qcow2
```

### Добавляем текущего пользователя me пользователя в группу kvm

```bash
sudo gpasswd -a me kvm
```
*или же можно сделать вот так*

```bash
sudo gpasswd -a $(whoami) kvm
```

### В зависимости от процессора Intel или AMD, прописываем модуль ядра в [/etc/modules-load.d/kvm.conf](https://raw.githubusercontent.com/akimdi/help-install-arch/master/kvm.conf)

```bash
sudo vim /etc/modules-load.d/kvm.conf
```

```bash
kvm_intel
```

### Или что бы не вписывать можно скачать конфигурационный файл kvm.conf (файл предназначен только для машин работающих под управлением процессоров Intel)

```bash
sudo wget --https-only --output-document=/etc/modules-load.d/kvm.conf https://raw.githubusercontent.com/akimdi/help-install-arch/master/kvm.conf
```

### Подгружаем модули ядра kvm_intel или kvm_amd в зависимости от процессора Intel или AMD

```bash
sudo modprobe kvm_intel
```

### Запускаем и устанавливаем в автозагрузку libvirtd

```bash
sudo systemctl start libvirtd
```

```bash
sudo systemctl enable libvirtd
```

```bash
sudo systemctl status libvirtd
```

### Создаём группу пользователей libvirt

```bash
sudo groupadd libvirt
```

### Добавляем пользователя me в группу libvirt

```bash
sudo gpasswd -a me libvirt
```

### Просмотр всех сетей в [virsh](https://libvirt.org/manpages/virsh.html)

```bash
sudo virsh net-list --all
```

### [Стартуем сеть](https://libvirt.org/manpages/virsh.html#net-start)

```bash
sudo virsh net-start default
```

### [Ставим сеть в автозагрузку](https://serverfault.com/a/577210)

```bash
virsh net-autostart default
```

### [Смотрим результат](https://libvirt.org/manpages/virsh.html#net-info)

```bash
virsh net-info default
```

### Запускаем [Virtual Machine Manager by Red Hat](https://virt-manager.org)

```bash
virt-manager
```

*Важно знать что после установки, в гостевую систему нужно установить пакет [spice-vdagent](https://askubuntu.com/a/858650). Например для Debian он находится [здесь](https://packages.debian.org/buster/spice-vdagent). Для ArchLinux [здесь](https://www.archlinux.org/packages/community/x86_64/spice-vdagent). Для Windows [здесь](https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe).*

*Eсли хотим подключить [shared folder](http://www.linux-kvm.org/page/9p_virtio) в гостевую систему нужно запустить virt-manager, открыть свою виртуальную машину, дважды щелкнув по ней. Нажать на детали виртуального оборудования (лампочка). Далее «Добавить оборудование» и выбрать файловую систему. Драйвер выбираем **Path**. Режим **Mapped**. Правила записи **Immediate**. Указываем путь на хостовой и на гостевой системах.*

![](https://sun9-24.userapi.com/c855520/v855520802/1ee4fc/J5SxyiEEcQA.jpg)

*А также обязательно выставляем видеодрайвер Virtio чтобы не было проблем с 3D графикой*

![](https://sun9-43.userapi.com/c857224/v857224955/d6b8d/PgFxGoGVPVY.jpg)

### В гостевой системе создаём папку и монтируем её

```bash
mkdir -p /home/me/projects
```

```bash
sudo mount -t 9p -o trans=virtio,version=9p2000.L /home/me/projects /home/me/projects
```

### Для [автомонтирования](https://unix.stackexchange.com/a/405677) при загрузке системы, следует прописать следующие стоки в файле /etc/fstab

```bash
sudo vim /etc/fstab
```

```bash
/home/me/projects /home/me/projects 9p noauto,x-systemd.automount,x-systemd.device-timeout=10,timeo=14,x-systemd.idle-timeout=0,trans=virtio,version=9p2000.L,rw 0 0
```

### Так как гостевая система работает от имени [libvirt-qemu](https://askubuntu.com/a/772831) пользователя, а настройки [ACL](https://wiki.archlinux.org/index.php/Access_Control_Lists) ограничивают [разрешения](https://unix.stackexchange.com/a/258208) этого пользователя, на хостовой операционной системе следует выполнить следующие команды

```bash
sudo chmod -R 777 /home/me/projects
```

```bash
sudo chown -R me:users /home/me/projects
```

```bash
sudo chmod -R 777 /var/lib/libvirt/images
```

```bash
sudo chown -R me:users /var/lib/libvirt/images
```

```bash
sudo groupadd libvirt
```

```bash
sudo usermod -G libvirt -a me
```

```bash
sudo groupadd libvirtd
```

```bash
sudo usermod -a -G libvirtd me
```

```bash
sudo useradd libvirt-qemu
```

```bash
sudo usermod -a -G libvirt-qemu me
```

```bash
sudo useradd kvm
```

```bash
sudo usermod -a -G kvm me
```

```bash
sudo setfacl -R -m u:libvirt-qemu:rwx /home/me/projects
```

```bash
sudo chown -R me:users /home/me/projects
```

### Для гостевой Windows [инструкция здесь](https://unix.stackexchange.com/q/86071)

### Для подключения по SSH нужно на гостевой системе узнать IP

```bash
sudo ip a
```

### Должно выдать что-то типо этого

```bash
enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:e3:07:bc brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.106/24 brd 192.168.122.255 scope global dynamic noprefixroute enp1s0
       valid_lft 3366sec preferred_lft 3366sec
    inet6 fe80::5054:ff:fee3:7bc/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

### Далее на хостовой системе уже выполняем подключение

```bash
ssh -p 22 me@192.168.122.106
```

***Полезные ссылки:***

[How to change the default Storage Pool from libvirt](https://serverfault.com/questions/840519/how-to-change-the-default-storage-pool-from-libvirt)

[Easy instructions to get QEMU/KVM and virt-manager up and running on Arch](https://gist.github.com/akimdi/2c02b2bf1123c9c4f83861f1c3254b19)

[Virt Tools Blog Planet](https://planet.virt-tools.org)

*Коротко о том что и где принято хранить:*

***/var/lib/libvirt/boot** — ISO-образы для установки гостевых систем.*

***/var/lib/libvirt/images** — образы жестких дисков гостевых систем.*

***/var/log/libvirt** — здесь следует искать все логи.*

***/etc/libvirt** — каталог с файлами конфигурации.*

*Далее можно установить виртуалку, а в качестве начального пособия рекомендую статью от [Александра Алексеева https://eax.me/kvm](https://eax.me/kvm)*

### Далее по-желанию можно настроить системные уведомления через [Dunst](https://wiki.archlinux.org/index.php/Dunst)

### А также установить полезные расширения для Firefox которые ускоряют и упрощают разработку и тестрирование в браузере

*Например контейнеры, которые открывают каждую вкладку в отдельном изолированном окружении что позволяет тестировать разные web-приложения не переключаясь в режим приватного просмотра или очищать куки и кэш*

[LanguageTool](https://addons.mozilla.org/firefox/addon/languagetool)

[Adguard](https://addons.mozilla.org/firefox/addon/adguard-adblocker)

[Always In Container](https://addons.mozilla.org/firefox/addon/always-in-container)

[CanvasBlocker](https://addons.mozilla.org/firefox/addon/canvasblocker)

[Container proxy](https://addons.mozilla.org/firefox/addon/container-proxy)

[Decentraleyes](https://addons.mozilla.org/firefox/addon/decentraleyes)

[Disconnect](https://addons.mozilla.org/firefox/addon/disconnect)

[Temporary Containers](https://addons.mozilla.org/firefox/addon/temporary-containers)

[Emoji Cheatsheet](https://addons.mozilla.org/firefox/addon/emoji-cheatsheet)

[Firefox Multi-Account Containers](https://addons.mozilla.org/ru/firefox/addon/multi-account-containers)

[Privacy Badger](https://addons.mozilla.org/firefox/addon/privacy-badger17)

[HTTPS Everywhere](https://addons.mozilla.org/firefox/addon/https-everywhere)

[Hide Tabs](https://addons.mozilla.org/firefox/addon/hide-tab)

[NoScript](https://addons.mozilla.org/firefox/addon/noscript)

[Privacy Possum](https://addons.mozilla.org/firefox/addon/privacy-possum)

[uMatrix](https://addons.mozilla.org/firefox/addon/umatrix)

[Block Site](https://addons.mozilla.org/firefox/addon/block-website)
