# Raspberry Pi VPN Router

> Ansible playbook to setup a VPN router using [OpenWrt](https://openwrt.org/) 21.02.3 and [ProtonVPN](https://protonvpn.com/) on a Raspberry Pi (RPI) 4B with a Realtek RTL8192CU USB WiFi adapter. Based on [NetworkChuck](https://youtu.be/jlHWnKVpygw), [OpenWrt](https://openwrt.org/docs/guide-user/services/vpn/openvpn/client), and [ProtonVPN](https://protonvpn.com/support/how-to-set-up-protonvpn-on-openwrt-routers/)
tutorials.

![Project image](project.png)

## Prerequisites

1. Flash OpenWrt to an SD card, see [here](https://firmware-selector.openwrt.org/?version=21.02.3&target=bcm27xx%2Fbcm2711&id=rpi-4) for the tutorial and [here](https://downloads.openwrt.org/releases/21.02.3/targets/bcm27xx/bcm2711/openwrt-21.02.3-bcm27xx-bcm2711-rpi-4-ext4-factory.img.gz) to download the factory image. If your RPI is already running OpenWrt, you can set `sysupgrade` to `yes` in [`roles/common/defaults/main.yml`](roles/common/defaults/main.yml) and download a sysupgrade image (named `*.img.gz`) to [`roles/common/files`](roles/common/files) to automatically update the RPI in the playbook.
2. Connect to your RPI via ethernet, see [here](https://openwrt.org/toh/raspberry_pi_foundation/raspberry_pi#how_to_connect_via_ethernet). By default, the IP address of your RPI is configured as static `192.168.1.1`.
3. Install Ansible, see [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
3. Install the [ansible-openwrt](https://github.com/gekmihesg/ansible-openwrt) role via `ansible-galaxy install gekmihesg.openwrt`
4. Download your OpenVPN config files (named `*.ovpn`) to [`roles/common/files`](roles/common/files). If you add multiple configurations, you can specify the default one using `default_openvpn_config` in [`roles/common/defaults/main.yml`](roles/common/defaults/main.yml).
5. Edit the secrets in [`group_vars/openwrt/vault.example.yml`](group_vars/openwrt/vault.example.yml), save as `group_vars/openwrt/vault.yml`, and encrypt using `ansible-vault encrypt group_vars/openwrt/vault.yml`. If necessary, adapt the default values in [`roles/common/defaults/main.yml`](roles/common/defaults/main.yml).

## Setup

1. Run `ansible-playbook site.yml -i hosts.yml --ask-vault-pass` to setup your RPI.
2. Change the root password: `ssh root@192.168.1.1 passwd`.

If you set `new_lan_ip` in `group_vars/openwrt/vault.yml` the playbook changes the IP address of your RPI and you need to adjust your local ethernet configuration. If you want to re-run the playbook, you will need to pass the new IP address:
`ansible-playbook site.yml -i hosts.yml --extra-vars "host_ip=<new_lan_ip>" --ask-vault-pass`.

## Usage

After running the playbook, your RPI should be connected to the WiFi specified by `vault_sta_interface` in `group_vars/openwrt/vault.yml`. Moreoever, it should provide a hotspot named `rpi_vpn` with password given by `vault_ap_interface_key` in `group_vars/openwrt/vault.yml`. Any device connected to this hotspot should automatically be using the VPN given by the configuration in [`roles/common/files`](roles/common/files). Check your device's [public IP address](https://ipleak.net/) and check for [DNS leaks](https://dnsleaktest.com/)!
