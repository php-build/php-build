php-build -- Builds multiple versions of PHP.
=============================================

## Install

Clone the Git Repository:

    % git clone git://github.com/CHH/php-build.git

Then go into the extracted/cloned directory and run:

    % ./install.sh

This installs php-build to default prefix which is `/usr/local`. 

To install php-build to an other location than `/usr/local` set the
`PREFIX` environment variable:

    % PREFIX=$HOME/local ./install.sh

If you don't have permissions to write to the prefix, then you 
have to run `install.sh` as superuser, either via `su -c` or via `sudo`.

## Changelog

### v0.7.0

 * Added support for 5.3.3, 5.3.12, 5.4.2 (loicfrering)
 * Commenting out the `extension_dir` in old `php.ini` files so the
   default extension dir is used. (sanemat)
 * Honor the `--lib-dir` which was defined in the definition file by the
   user (#61). (grota)
 * Added support for patching releases by separating the
   download/extract step from the build step (#60). (grota)
 * Updated XDebug in all definitions to `v2.2.0`.
 * Added a `Vagrantfile` for setting up an Ubuntu 10.10 environment for
   testing php-build.
 * Added a simple automated testing system using [bats][] (see
   `run-tests.sh`). There are 3 configurations:
   * `all`: Builds all builtin definitions and runs the test suite on
     each of them.
   * `stable`: Builds the most recent versions of the 5.3 and 5.4
     series.
   * Supply a definition name and it builds only the definition and runs
     the test suite on it.

[bats]: https://github.com/sstephenson/bats

### v0.6.2

 * Fixed bug #57: Automatic enabling of extension does not work with
   `pecl` command.

### v0.6.1

 * Added support for 5.4.3, 5.3.13

### v0.6.0

 * php-build now works as plugin to
   [humanshell/phpenv](http://github.com/humanshell/phpenv)
(humanshell).
 * Added support for 5.4.1, 5.3.11
 * Better handling of `*.dSYM` executables (CHH, eriksencosta).

### v0.5.0

 * Added `--pear` flag to install the good old pear installer alongside
   of Pyrus.
 * Added 5.4.1RC1, 5.4.1RC2, 5.3.11RC1, and 5.3.11RC2 (loicfrering).
 * Removed a hack which renamed generated debug symbols on OSX.
 * Removed IMAP from enabled extensions.
 * Added experimental `with_apxs2`, which makes an Apache HTTPD module.
 * Fix `install.sh` by removing the unused `LOG_DIR` variable (suin).

### v0.4.0

 * XDebug was updated to 2.1.3 in all `5.2.x` and `5.3.x` definitions.
 * PEAR and Pyrus can be installed along each other. This is
   experimental though.
 * Added `php-build.5` about the definition file format.
 * A particular revision can be passed to `install_xdebug_master`
   (loicfrering).
 * Added definition for 5.4.0 final (loicfrering).

