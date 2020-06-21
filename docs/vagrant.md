vagrant plugin install vagrant-disksize vagrant-libvirt vagrant-digitalocean vagrant-netinfo vagrant-address vagrant-notify



---

vagrant init laravel/homestead --box-version $(curl -Ls https://api.github.com/repos/laravel/settler/releases/latest | jq -r ".tag_name" | sed -e "s/^.\{1\}//") && vagrant up