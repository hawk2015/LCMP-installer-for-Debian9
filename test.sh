#!/bin/bash

provideremail=""

echo ""
echo "  Enter your $(tput setaf 3)Cloudflare Email$(tput sgr0) for enabling the DNS Challenge"
read -r -p "  Email: " domainmail
  until [[ "$domainmail" == *@*.* || "$domainmail" == off ]]; do
    echo ""
    echo "  Invalid email"
    echo "  Type $(tput setaf 3)off$(tput sgr0) if you don't want https"
    read -r -p "  Email: " domainmail
  done

provideremail=$domainmail

echo "Email=$provideremail
" >> 1.txt
