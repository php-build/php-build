#!/usr/bin/env bash

# Install the plugin in PREFIX directory (where php-build is installed).
# 
# In case of php-build is installed in another location,
# the script can look for a environment variable PREFIX,
# that defaults to /usr/local.
# 
# In case of user doesn't have write permissions in PREFIX directory,
# the script will prompt for super user(sudo) password.
#
set -e

TMP_DIR=$(mktemp -d -t php-build-plugin-composer)

if [ -z "${PREFIX}" ]; then
    PREFIX="/usr/local"
fi

if [ ! -d "${PREFIX}" ]; then
  echo ""
  echo "***ERROR***: The PREFIX directory (${PREFIX}) doesn't exists. Check if php-build is already installed in that location"
  exit
fi


echo "Installing php-build-plugin-composer in \"${PREFIX}\""

echo -n "  - Downloading plugin..."
cd ${TMP_DIR}
rm -rf php-build-plugin-composer-master master.tar.gz

# try to download plugin via wget, or via curl, or via git clone
# otherwise, warn the user
((wget https://github.com/rogeriopradoj/php-build-plugin-composer/archive/master.tar.gz --no-check-certificate && tar -vzxf master.tar.gz) 2>/dev/null) || ((curl -LO https://github.com/rogeriopradoj/php-build-plugin-composer/archive/master.tar.gz && tar -vzxf master.tar.gz) 2>/dev/null) || ((git clone https://github.com/rogeriopradoj/php-build-plugin-composer.git php-build-plugin-composer-master) 2>/dev/null) || (echo ""; echo "***ERROR***: You do not have either wget, neither curl or git installed on your system to download the needed files."; echo "Please, check that, and after, try to install this plugin again."; exit;)
echo " Done."

echo -n "  - Making the plugin executable..."
cd ${TMP_DIR}/php-build-plugin-composer-master
chmod +x share/php-build/after-install.d/composer.sh
echo " Done."

echo "  - Moving plugin to your php-build PREFIX \"${PREFIX}\"..." 
echo -n "    (your sudo password may be prompted)"
echo ""
echo ""
echo ""
if [ touch ${PREFIX}/foo 2>/dev/null && rm -f ${PREFIX}/foo ]; then
    cp -r share $PREFIX
else
    sudo cp -r share $PREFIX
fi    

echo "     ... Done."

echo ""
echo ""
echo ' All done!!!'
echo "------------"
echo ""
echo ' The plugin composer has been installed. Your next builds made with php-build will have command composer enabled.'