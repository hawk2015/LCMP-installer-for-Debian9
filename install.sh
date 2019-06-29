#!/bin/bash
#
red="tput setaf 1"
blue="tput setaf 2"
yellow="tput setaf 3"
green="tput setaf 4"
purple="tput setaf 5"
normal="tput sgr0"

phppath="/etc/php"
phpversion="php7.3-fpm"
phpsock="/run/php/$phpversion.sock"

caddywww="/var/www" # folder where public files should be
caddyuser="www-data" # user under caddy is gonna be running

about () {
	echo ""
	echo "  ========================================================= "
	echo "  \          LCMP Installer for Debian9 x64                / "
	echo "  \                   version=v1.0                         / "
	echo "  \          Linux:  Debian9 x64                           / "
	echo "  \          Caddy: Caddy web server v1.0.0                / "
	echo "  \          MariaDB : mysql branch                        / "
	echo "  \          Php : php7.3                                  / "
	echo "  ========================================================= "
	echo ""
}

#install php
installphp () {
	if [[ -e "$phppath" ]] ; then
			  echo "PHP was installed!"
	  else
				# Install PHP
	      apt install ca-certificates apt-transport-https -y;
				wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
	      echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
					echo ""
					apt update;
					apt install $phpversion -y;
					apt install php7.3 php7.3-mysql php7.3-gd php7.3-xml php7.3-cgi php7.3-cli php7.3-curl php7.3-zip php7.3-mbstring unzip -y
					echo ""
	 fi
	 # Detect Caddyfile, and setup information
	 if [[ -e "/etc/caddy/Caddyfile" ]]; then
	 	sed -i "4i\\\t fastcgi / /run/php/$phpversion.sock php" /etc/caddy/Caddyfile
		fi
		# enable service startup and run
		systemctl enable $phpversion
		systemctl start $phpversion
		echo ""
		echo " PHP installation was[$($blue)DONE$($normal)]"
		echo ""
}
#install MariaDB
installsql() {
	apt update;
	apt install mariadb-server;
	mysql_secure_installation
	echo ""
}

# intsall wordpress
installwp() {
	mkdir $caddywww/wordpress;
	cd $caddywww/wordpress;
	wget https://wordpress.org/latest.tar.gz;
	tar xvf  latest.tar.gz;
	mv wordpress/* .;
	rm wordpress/ -rf;
	chown $caddyuser:$caddyuser $caddywww/wordpress
	echo ""
	echo " Wordpress installation was[$($blue)DONE$($normal)]"
	echo ""
}

#check Caddy Installer script
if [[ -e "/tmp/caddy" ]]; then
	echo ""
	echo "  Removing old isntall script"
	rm -f /tmp/caddy
fi
echo ""
cd /tmp
wget -q https://raw.githubusercontent.com/hawk2015/LCMP-installer-for-Debian9/master/caddy && chmod +x caddy
mv caddy /tmp &>/dev/null
echo ""

input=
until
 echo "----------LCMP Control Manu-----------"
 echo "Please enter your choise:(1-9)"
 echo "1. $($yellow)Install$($normal) Caddy Web Server"
 echo "2. $($yellow)Install$($normal) Caddy with plugins：http.cache,http.cors,http.expires,http.filter,http.git,tls.dns.cloudflare"
 echo "3. $($blue)Start$($normal) Caddy Web Server"
 echo "4. $($blue)Stop$($normal) Caddy Web Server"
 echo "5. $($blue)Check $($normal) Status of Caddy Web Server"
 echo "6. $($blue)Backup$($normal) The Caddy Config Files"
 echo "7. $($blue)Restore$($normal) The Caddy Config Files"
 echo "8. $($red)Delete$($normal) Caddy Web Server"
 echo "9. $($blue)Install$($normal) PHP7.3"
 echo "10. $($yellow)Install$($normal) MariaDB (branch of MySQL)"
 echo "11. $($yellow)Install$($normal) Wordpress"
 echo "12. about"
 echo "13. Exit Menu"
 echo "--------------------------------------"

 read -r -p "  Input Number: " inputnum
 test $inputnum -eq 13
 do

  case $inputnum in
 1) bash /tmp/caddy install;;
 2) bash /tmp/caddy install http.cache,http.cors,http.expires,http.filter,http.git,tls.dns.cloudflare;;
 3) bash /tmp/caddy start;;
 4) bash /tmp/caddy stop;;
 5) bash /tmp/caddy status;;
 6) bash /tmp/caddy backup;;
 7) bash /tmp/caddy restore;;
 8) bash /tmp/caddy delete;;
 9) installphp;;
 10) installsql;;
 11) installwp;;
 12) about;;
 *) echo "Sorry, Wrong number. try again, please!";;
   esac

 done
exit;
