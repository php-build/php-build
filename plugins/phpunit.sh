
after_install "install_phpunit"

install_phpunit() {
    pyrus="$PREFIX/bin/pyrus"

    # Set up the required channels
    "$pyrus" channel-discover "components.ez.no" > /dev/null
    "$pyrus" channel-discover "pear.symfony-project.com" > /dev/null
    "$pyrus" channel-discover "pear.phpunit.de" > /dev/null

    _ezcomponents_hack

    "$pyrus" install "phpunit/PHPUnit" > /dev/null
}

# ezComponents' PEAR Channel somehow not works with Pyrus
# so manually download and install the package files.
_ezcomponents_hack() {
    local ezcBase="Base-1.8.tgz"
    local ezcConsoleTools="ConsoleTools-1.6.1.tgz"

    [[ ! -d "$PHP_BUILD_ROOT/packages/ezc" ]] && mkdir "$PHP_BUILD_ROOT/packages/ezc"

    if [ ! -f "$PHP_BUILD_ROOT/packages/ezc/$ezcBase" ]; then
        _download_ezc_component $ezcBase
    fi

    if [ ! -f "$PHP_BUILD_ROOT/packages/ezc/$ezcConsoleTools" ]; then
        _download_ezc_component $ezcConsoleTools
    fi

    pyrus="$PREFIX/bin/pyrus"

    "$pyrus" install -f "$PHP_BUILD_ROOT/packages/ezc/$ezcBase" > /dev/null
    "$pyrus" install -f "$PHP_BUILD_ROOT/packages/ezc/$ezcConsoleTools" > /dev/null
}

_download_ezc_component() {
    local package=$1
    local url="http://components.ez.no/get/$package"

    wget -P "$PHP_BUILD_ROOT/packages/ezc" "$url" > /dev/null
}
