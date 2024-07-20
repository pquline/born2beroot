# Born2beroot

```txt
	   (                   )   )                       )
	 ( )\      (        ( /(( /(    (  (            ( /(
	 )((_)  (  )(   (   )(_))\())  ))\ )(   (    (  )\())
	((_)_   )\(()\  )\ |(_)((_)\  /((_|()\  )\   )\(_))/
	 | _ ) ((_)((_)_(_/(_  ) |(_)(_))  ((_)((_) ((_) |_
	 | _ \/ _ \ '_| ' \)) /| '_ \/ -_)| '_/ _ \/ _ \  _|
	 |___/\___/_| |_||_/___|_.__/\___||_| \___/\___/\__|
```

## Authentication

- Encryption passphrase: `[password]`
- \[username]42 login: `[username]`
- Password: `[password]`
- Root password: `[password]`

## Installing the Virtual Machine

### Create the VM

- `New`
- Name: `Born2beroot`
- Machine Folder: `/sgoinfre/goinfre/Perso/[username]`
- Type: `Linux`
- Version: `Debian (64-bit)`
- Memory size: `1024MB`
- Hard disk: `Create a virtual hard disk now`
- File size: `31GB`
- Hard disk file type: `VDI (VirtualBox Disk Image)`
- Storage on physical hard disk: `Dynamically allocated`
- `Start`

### Install Debian

- Select *Debian ISO image*
- Select `Install`
- Select *language*
- Select *geographical & keyboard layout settings*
- Hostname: `[username]42`
- Domain name: *leave empty*
- Root password: `[password]`
- Username: `[username]`
- Name: `[username]`
- User password: `[password]`

### Partition disks

- Partitioning method: `Manual`
- Select volume: `SCI2 (0,0,0) (sda) (...)`
- Create new empty partition: `Yes`
- `pri/log	xxGB	FREE SPACE` > `Create a new partition` > `500MB` > `Primary` > `Beginning` > `Mount point` > `/boot` > `Done setting up the partition`
- `pri/log	xxGB	FREE SPACE` > `Create a new partition` > `max` > `Logical` > `Mount point` > `Do not mount it` > `Done setting up the partition`
- Select `Configure encrypted volumes`
- Write the changes to disk and configure encrypted volumes: `Yes`
- Encryption configuration actions: `Create encrypted volumes`
- Devices to encrypt: `/dev/sda5`
- `Done setting up the partition` > `Finish` > `Yes`
- Encryption passphrase: `[password]`

### Logical Volume Manager

- Select `Configure the Logical Volume Manager`
- Write the changes to disks and configure LVM: `Yes`
- Select `Create volume group`
- Volume group name: `LVMGroup`
- Select `/dev/mapper/sda5_crypt`
- `Create Logical Volume` > `LVMGroup` > `root` > `10G`
- `Create Logical Volume` > `LVMGroup` > `swap` > `2.3G`
- `Create Logical Volume` > `LVMGroup` > `home` > `5G`
- `Create Logical Volume` > `LVMGroup` > `var` > `3G`
- `Create Logical Volume` > `LVMGroup` > `srv` > `3G`
- `Create Logical Volume` > `LVMGroup` > `tmp` > `3G`
- `Create Logical Volume` > `LVMGroup` > `var-log` > `4G`
- Select `Finish`
- Filesystems and mount points:
  - `LV home`: `Ext4` / `/home`
  - `LV root`: `Ext4` / `/`
  - `LV srv`: `Ext4` / `/srv`
  - `LV swap`: `swap area`
  - `LV tmp`: `Ext4` / `/tmp`
  - `LV var`: `Ext4` / `/var`
  - `LV var-log`: `Ext4` / `/var/log`
- Select `Finish partitioning and write changes to disk`
- Write the changes to disk: `Yes`

### Finish installation

- Scan extra installation media: `No`
- Select *country* & *mirror*
- HTTP proxy information (blank for none):
- Participate in the package usage survey: `No`
- Choose software to install:
- Install the GRUB boot loader to your primary drive: `Yes` > `/dev/sda`
- `Continue`

## Configuration

### Basics (as su)

- switch to root: `su -`
- update OS: `apt update -y`
- upgrade OS: `apt upgrade -y`
- install wget: `apt install wget -y`

### Users and sudo (as super user)

- change passwords policies: `vim /etc/login.defs`

```bash
PASS_MAX_DAYS	30
PASS_MIN_DAYS	2
PASS_WARN_AGE	7
```

- install sudo: `apt install sudo -y`
- add user to sudo group: `usermod -aG sudo [username]`
- see password policy per user: `chage -l [username]`
- change password policy for user:

```bash
chage -M 30 [username]	# M: maximum number of days between password change
chage -m 2 [username]	# m: minimum number of days between password change
chage -W 7 [username]	# W: number of days of warning before password expires
# OR
chage [username]
```

- create log directory: `mkdir /var/log/sudo`
- edit /etc/sudoers: `visudo`

```txt
Defaults	passwd_tries=3
Defaults	badpass_message="This looks nothing like the actual password..."
Defaults	logfile="/var/log/sudo/sudo.log"
Defaults	log_input
Defaults	log_output
Defaults	requiretty
```

### Customization

- install zsh:

```bash
sudo apt install zsh -y
sudo sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

- install vim: `sudo apt install vim -y`
- install toilet: `sudo apt install toilet -y`
- install neofetch: `sudo apt install neofetch -y`
- install bat: `sudo apt install bat -y`
- edit `.zshrc` `vim ~/.zshrc && source ~/.zshrc`:

```bash
# CUSTOMIZATION

alias vz="vim ~/.zshrc && source ~/.zshrc"
alias c="clear"
alias h="history"
alias mkdir="mkdir -pv"
alias sd="sudo shutdown now"
alias bat="/usr/bin/batcat"

# EVALUATION

STYLE='\033[0;32m\033[1m'
NO_STYLE='\033[0m'

# echo '$STYLE$  $NO_STYLE' &&

alias print_users="echo '$STYLE$ sudo cat /etc/passwd | awk -F: \"{print \$1}\" $NO_STYLE' && sudo cat /etc/passwd | awk -F: '{print \$1}'"
alias print_groups="echo '$STYLE$ sudo getent group | awk -F: \"{print \$1}\" $NO_STYLE' && sudo getent group | awk -F: '{print \$1}'"
alias check_monitoring_script="echo '$STYLE$ bat /usr/local/bin/monitoring.sh$NO_STYLE' && bat /usr/local/bin/monitoring.sh"
alias check_debian="echo '$STYLE$ bat /etc/os-release $NO_STYLE' && bat /etc/os-release"
alias check_ufw_status="echo '$STYLE$ sudo systemctl status ufw $NO_STYLE' && sudo systemctl status ufw"
alias check_ssh_status="echo '$STYLE$ sudo systemctl status ssh $NO_STYLE' && sudo systemctl status ssh"
alias check_groups="echo '$STYLE$ groups [username] | grep -E \"sudo|user42\" $NO_STYLE' && groups [username] | grep -E 'sudo|user42'"
alias create_user="echo '$ sudo adduser [user]\n$ libpam-pwquality'"
alias create_group="echo '$ sudo groupadd evaluating\n$ sudo usermod -aG evaluating [user]\n$ sudo groups [user] | grep \"evaluating$\"'"
alias check_password_policies="echo '$ bat /etc/login.defs\n$ bat /etc/security/pwquality.conf\n$ chage [user]'"
alias check_hostname="echo '$STYLE$ hostname $NO_STYLE' && hostname"
alias change_hostname="echo '$ sudo hostnamectl set-hostname [username]42\n$ sudo vim /etc/hosts\nsudo reboot'"
alias check_partitions="echo '$STYLE$ lsblk $NO_STYLE' && lsblk"
alias check_sudo_installation="echo '$STYLE$ sudo --version $NO_STYLE' && sudo --version"
alias assign_sudo="echo '$ sudo usermod -aG sudo [user]'"
alias check_sudo_rules="echo '$STYLE$ sudo visudo $NO_STYLE' && sudo visudo"
alias check_sudo_directory="echo '$STYLE$ cd /var/log/sudo && ls -lh $NO_STYLE' && cd /var/log/sudo && ls -lh"
alias check_ufw_installation="echo '$STYLE$ sudo ufw --version $NO_STYLE' && sudo ufw --version"
alias check_ufw_rules="echo '$STYLE$ sudo ufw status verbose $NO_STYLE' && sudo ufw status verbose"
alias add_ufw_rule="echo '$STYLE$ sudo ufw allow 8080 && sudo ufw status verbose $NO_STYLE' && sudo ufw allow 8080 && sudo ufw status verbose"
alias delete_ufw_rule="echo '$STYLE$ sudo ufw delete allow 8080 && sudo ufw status verbose $NO_STYLE' && sudo ufw delete allow 8080 && sudo ufw status verbose"
alias check_ssh_installation="echo '$STYLE$ ssh -V $NO_STYLE' && ssh -V"
alias check_wordpress="echo '$STYLE> http://localhost:8042 $NO_STYLE' && echo '$STYLE$ cd /var/www/html/ $NO_STYLE' && cd /var/www/html/ && echo '$STYLE$ sudo lighttpd -v $NO_STYLE' && sudo lighttpd -v && echo '$STYLE$ sudo mariadb -V $NO_STYLE' && sudo mariadb -V && echo '$STYLE$ sudo php -v $NO_STYLE' && sudo php -v"
alias check_jellyfin="echo '$STYLE> http://localhost:8096 $NO_STYLE' && echo '$STYLE$ sudo systemctl status jellyfin.service $NO_STYLE' && sudo systemctl status jellyfin.service"
```

### UFW

- install UFW: `sudo apt install ufw -y`
- enable UFW: `sudo ufw enable`
- allow port 4242: `sudo ufw allow 4242`
- check status: `sudo ufw status verbose`

### SSH

- install ssh: `sudo apt install openssh-server -y`
- configure `sudo vim /etc/ssh/sshd_config`:

```bash
(...)
Port 4242
#AddressFamily any
#ListenAddress 0.0.0.0
(...)
# Authentication:

#LoginGraceTime 2m
PermitRootLogin no
(...)
```

- configure `sudo vim /etc/ssh/ssh_config`:

```bash
(...)
#	IdentifyFile ~/.ssh/id_ed25519
Port 4242
(...)
```

- restart ssh: `sudo systemctl restart ssh`
- check ssh status: `sudo systemctl status ssh`
- `VirtualBox` > `Born2beroot` > `Settings` > `Network` > `Advanced` > `Port Forwarding`
- Name: `ssh` | Protocol: `TCP` | Host Port: `4343` | Guest Port: `4242` > `OK`
- restart ssh: `sudo systemctl restart ssh`
- ssh to virtual machine: `ssh [username]@localhost -p 4343`
- *Note: a web service is already running on port 4242 on host machine*

### Password quality

- install password quality library: `sudo apt install libpam-pwquality -y`
- edit password quality configuration: `sudo vim /etc/security/pwquality.conf`

```conf
difok = 7			# number of characters in the new password that must not be present in the old password
minlen = 10			# minimum acceptable length for the new password
dcredit = -1		# maximum credit for having digits in the new password (if less than 0, number of mandatory digits in the new password)
ucredit = -1		# maximum credit for having uppercase characters in the new password (if less than 0, number of mandatory uppercase characters in the new password)
maxrepeat = 3		# maximum number of allowed consecutive same characters in the new password
usercheck = 1		# wheter to check if it contains the username in some form (0: false, 1: true)
retry = 3			# maximum number of tries a user can enter wrong passwords before returning an error
enforce_for_root	# enforces pwquality checks on the root user password
```

- change passwords to comply to policies: `sudo passwd root` `sudo passwd [username]`

### Monitoring

- create the script: `sudo vim /usr/local/bin/monitoring.sh`
- copy-paste the script: [monitoring.sh](monitoring.sh)
- create the cron job: `sudo crontab -e`

```txt
*/10	*	*	*	*	/usr/local/bin/monitoring.sh
```

### Wordpress

- install lighttpd: `sudo apt install lighttpd -y`
- open port 80: `sudo ufw allow 80`
- `VirtualBox` > `Born2beroot` > `Settings` > `Network` > `Advanced` > `Port Forwarding`
- Name: `http` | Protocol: `TCP` | Host Port: `8042` | Guest Port: `80` > `OK`
- install zip: `sudo apt install zip -y`
- change working directory: `cd /var/www`
- download wordpress: `sudo wget https://wordpress.org/latest.zip`
- unzip and delete: `sudo unzip latest.zip && sudo rm latest.zip`
- change folders names: `sudo mv html html_old` `sudo mv wordpress html`
- change permissions: `sudo chmod 755 html`
- install MariaDB: `sudo apt install mariadb-server -y`
- restrict access to server: `sudo mysql_secure_installation`

```txt
Switch to unix_socket autentication? → N
Change the root password? → N
Remove anonymous users? → Y
Disallow root login remotely? → Y
Remove test database and acces to it? → Y
Reaload privilege tables now? → Y
```

- access MariaDB: `sudo mariadb`
- create database: `CREATE DATABASE wordpress;`
- check if database was created: `SHOW DATABASES;`
- create user: `CREATE USER '[username]'@'localhost' IDENTIFIED BY 'password';`
- update persmissions to take effect: `FLUSH PRIVILEGES;`
- exit mariadb: `exit`
- install PHP: `sudo apt install php-cgi php-mysql -y`
- change working directory: `sudo cd /var/www/html`
- copy config file: `sudo cp wp-config-sample.php wp-config.php`
- edit config file: `sudo vim wp-config.php`
- enable modules in lighttpd to improve performance: `sudo lighty-enable-mod fastcgi` `sudo lighty-enable-mod fastcgi-php` `sudo service lighttpd force-reload`
- solve problem:

```sql
GRANT ALL PRIVILEGES ON wordpress.* TO '[username]'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
```

- connect to wordpress and enter details: `localhost:8042`

### Jellyfin

- install Jellyfin: `wget -q -O- https://repo.jellyfin.org/install-debuntu.sh | sudo bash`
- connect to Jellyfin: `localhost:8096`

## Defense

### Signature

```bash
cd ~/sgoinfre/Born2beroot
sha1sum Born2beroot.vdi > evaluation_signature.txt
diff evaluation_signature.txt signature.txt
```

### Project Overview

- basic functionning of the VM
- choice of OS
- basic differences between Rocky and Debian
- benefits of VMs
- difference between aptitude and apt
- APPArmor
- monitoring.sh

### Simple Configuration

- verify that the machine does not have a graphical environment at startup
- password with user \[username]: 1 uppercase, 1 digit, 10+ characters (`[password]`)
- verify that the OS is Debian
- UFW service is launched
- SSH service is launched

### User

- verify that `[username]` user belongs to the `sudo` and `user42` groups
- create a new user and assign them a password respecting the subject's rules
- explain how is was possible to implement the requested rules on the VM (show files)
- create a group called `evaluating` and assign it to the new user
- check that the new user belongs to the `evaluating` group
- explain the purpose of the password policy
- explain the advantages and disadvantages of the password policy's implementation

### Hostname and Partitions

- verify that the hostname of the machine is formatted as follows: `[username]42`
- change the hostname by replacing the login with the corrector's login, then restart the machine
- check that the hostname has been changed, then restore the original hostname
- show the partitions of the VM
- compare the output with the example given in the subject (see bonus part)
- give a brief explanation of how LVM works
- explain the benefits of LVM

### SUDO

- verify that the `sudo` program is installed on the VM
- show how to assign the new user to the `sudo` group
- explain the purpose and operation of `sudo` with examples
- demonstrate the implementation of the rules imposed by the subject
- verify that the `/var/log/sudo/` directory exists and contains at least one file
- check the contents of the files in this directory and observe the commands used with `sudo`
- attempt to run a command via `sudo`, then check if the files have been updated

### UFW

- verify that the UFW program is installed on the virtual machine
- verify that the UFW program is functioning correctly
- give a basic explanation of what UFW is and why it's important to use it
- list the active rules in UFW and check that there's a rule for port 4242
- add a new rule to open port 8080 and check that it's been added by listing the active rules
- delete this new rule

### SSH

- verify that the SSH service is installed on the VM
- verify that the SSH service is functioning correctly
- give a basic explanation of what SSH is and why it's important to use it
- verify that the SSH service uses only port 4242
- connect via SSH with the newly created user
- ensure that SSH cannot be used with the root user, as indicated in the subject

### Script Monitoring

- explain the operation of the script by displaying its code
- explain what `cron` is
- explain how the script was set up to execute every 10 minutes from server launch
- verify the proper functioning of the script
- edit the cron job to make sure that the script executes every minute
- launch programs to make sure that the script runs correctly with dynamic values
- edit the cron job to make sure that the script no longer runs at server launch (without modifying the script itself)
- restart the server and verify that the script still exists in the same place, that its permissions have remained unchanged and that it has not been modified

### Bonus

- verify the implementation of partitions (2 points)
- verify the setup of WordPress with the services listed in the subject (lighttpd, MariaDB, PHP) (2 points)
- free-choice service (Jellyfin) (1 point):
  - test the proper functioning and implementation of each additional service
  - explain the service and the reasons behind this choice
