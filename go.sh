#!/bin/bash
#
# Caddy Web Server Installer script
#


if [[ -e "/etc/init.d/caddy" ]]; then
	echo ""
	echo "  Removing old Caddy script"
	rm -f /tmp/caddy
fi
echo ""
echo "  Setting up Caddy"
cd /tmp
wget -q https://raw.githubusercontent.com/hawk2015/LCMP-installer-for-Debian9/master/caddy;
chmod +x caddy;
mv caddy /tmp
echo "  Done. run 'caddy' to use Caddy"
echo ""
exit;
