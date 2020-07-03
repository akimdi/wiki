### Настраиваем [Vagrant](https://app.vagrantup.com/laravel/boxes/homestead) и [Homestead](https://github.com/laravel/settler)

```bash
vagrant plugin install vagrant-disksize vagrant-libvirt vagrant-digitalocean vagrant-netinfo vagrant-address vagrant-notify
```

```bash
vagrant plugin update
```

### Переходим с папку с проектом и инициализируем Homestead

```bash
vagrant init laravel/homestead --box-version $(curl -Ls https://api.github.com/repos/laravel/settler/releases/latest | jq -r ".tag_name" | sed -e "s/^.\{1\}//")
```

```bash
vagrant up
```

```bash
vagrant ssh
```