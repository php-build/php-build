php-build -- Builds multiple versions of PHP.
=============================================

## Install

Clone the Git Repository:

    % git clone git://github.com/humanshell/php-build.git

Then go into the extracted/cloned directory and run:

    % ./install.sh

This installs php-build to default prefix which is `/usr/local`. 

To install php-build to an other location than `/usr/local` set the
`PREFIX` environment variable:

    % PREFIX=$HOME/local ./install.sh

If you don't have permissions to write to the prefix, then you 
have to run `install.sh` as superuser, either via `su -c` or via `sudo`.

If you only intend to use php-build via
[phpenv](https://github.com/humanshell/phpenv) then you can install it locally
as a plugin:

    $ mkdir -p ~/.phpenv/plugins
    $ cd ~/.phpenv/plugins
    $ git clone git://github.com/humanshell/php-build.git

