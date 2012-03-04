# php-build(1) -- Builds PHP versions with their coexistence in mind.

## SYNOPSIS

`php-build` `--definitions` <br>
`php-build` [`-i`|`--ini` <var>env</var>] <var>definition</var> <var>prefix</var>

## DESCRIPTION

`php-build` builds common PHP versions so, that they
can be used side by side in a development environment.

`php-build` works with written **definitions** for each
PHP version which you want to build. These definitions
typically include directives, which tell where to download
the source package, which XDebug version to use (if any)
or add/remove/replace specific build options.

To list all available definitions pass the `--definitions`
flag. Definitions are looked up in `share/php-build/definitions`.

To build a definition pass it as the <var>definition</var> argument
and the path where you want to place the compiled artifacts
as <var>prefix</var> argument.

The <var>definition</var> argument either expects a definition name as
listed by `--definitions`, or a path to the definition file you
want to use.

**Important:** You *cannot* move the <var>prefix</var> folder
afterwards. All paths are written *absolute* to all
generated configs and executables!

For example to build PHP 5.4.0beta2 into your `~/local`
folder with development configuration:

`$ php-build --ini development 5.4.0beta2 ~/local/5.4.0beta2`

Here is a quick overview of what is stored where:

 * `bin/`, Contains the PHP executables and all executables installed via `pear` or `pyrus`.
 * `bin/php`, The PHP Executable
 * `bin/pyrus`, a Pyrus executable, which installs packages _local_ to this PHP version.
 * `bin/pear`, a PEAR executable, which installs packages _local_ to this PHP version.
 * `etc/php.ini`
 * `etc/conf.d/`, PHP is configured to look for additional
   `.ini` files in this directory. Place your extension's 
   config files or your config overrides here.
 * `pear/`, here are PHP source files of PEAR packages installed
   via `pear` located.
 * `share/pyrus/.pear/php`, here are the source files of PEAR packages located 
   which were installed via `pyrus`. This is configured as Include Path.

### Definitions

Definitions are the *blueprints* for building PHP versions. Definitions
are Shell Scripts, which call some predefined functions. Definitions are
stored in `share/php-build/definitions`. `php-build` ships with
definitions for common PHP releases starting with PHP 5.3. You can
take a look at these to get a feel for them.

`php-build` defines utility functions for building a PHP source tarball
and manipulating config files. `php-build` supports
**plugins** which provide additional functions for usage within
definitions. Plugins must have the extension `.sh` and 
are looked up in `share/plugins.d`.

`php-build` ships with these plugins:

 * `pyrus`, Provides a `install_pyrus` command which downloads
   a `pyrus.phar` and sets up a Pyrus install local to this <var>prefix</var>
 * `xdebug`, Provides the `install_xdebug` <var>version</var> and
   `install_xdebug_master` commands. Use `install_xdebug_master`
   for building development versions of PHP and `install_xdebug`
   <var>version</var> for building stable releases.

For more information about the definition file format see php-build(5).

### pear vs. pyrus

Currently [Pyrus](http://pear2.php.net/PEAR2_Pyrus) is provided
as the default installer for PEAR packages in the shipped definitions.

If you want to use the `pear` command for managing PEAR packages add
`with_pear` before the call to `install_package`. You __should remove__ the 
`install_pyrus` from the definition, otherwise the include paths
will be messed up and installed executables will conflict as they both
install them to `$PREFIX/bin`.

The `pear` command installs PHP source files to `$PREFIX/pear` and
executables to `$PREFIX/bin`.

## OPTIONS

 * `--definitions`:
   Lists all definitions, which are available to build.
 * `-i` <var>env</var>, `--ini` <var>env</var>:
   Tells `php-build` to use the `php.ini`-<var>env</var>
   from the PHP source archive. Typically you would
   use either `production` or `development`. Creates an
   empty `php.ini` by default.

## ENVIRONMENT

 * `PHP_BUILD_DEBUG`, set this to `yes` to trigger a `set -x`
   call. This echo's all issued shell commands of the script.
 * `PHP_BUILD_XDEBUG_ENABLE`, set to `off` to comment out the
   lines which enable XDebug, in the generated `xdebug.ini`.

## COPYRIGHT

php-build is Copyright (C) 2011 Christoph Hochstrasser
<http://christophh.net>.


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[Definitions]: #Definitions "Definitions"
[OPTIONS]: #OPTIONS "OPTIONS"
[ENVIRONMENT]: #ENVIRONMENT "ENVIRONMENT"
[COPYRIGHT]: #COPYRIGHT "COPYRIGHT"


[php-build(1)]: php-build.1.html
