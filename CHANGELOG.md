# php-build changelog

## 1.0.0 - Upcoming

* Added: uninstaller script #279
* Fixed: installer fails if share directory doesn't exist
* Fixed: Build error when trying to use definition file #285
* Added: environment variable PHP_BUILD_KEEP_OBJECT_FILES to "make clean" after installation or not #317
* Removed pear and pyrus support
* Fixed: environment variable `PHP_BUILD_DEFINITION_PATH` wasn't used internally #350
* Added PHP 5.3 definitions: `5.3.27`, `5.3.28`, `5.3.29`
* Added PHP 5.4 definitions: `5.4.17`, `5.4.18`, `5.4.19`, `5.4.20`, `5.4.21`, `5.4.22`, `5.4.23`, `5.4.24`, `5.4.25`, `5.4.26`, `5.4.27`, `5.4.28`, `5.4.29`, `5.4.30`, `5.4.31`, `5.4.32`, `5.4.33`, `5.4.34`, `5.4.35`, `5.4.36`, `5.4.37`, `5.4.38`, `5.4.39`, `5.4.40`, `5.4.41`, `5.4.42`, `5.4.43`, `5.4.44`, `5.4.45`
* Added PHP 5.5 definitions: `5.5.0`, `5.5.1`, `5.5.2`, `5.5.3`, `5.5.4`, `5.5.5`, `5.5.6`, `5.5.7`, `5.5.8`, `5.5.9`, `5.5.10`, `5.5.11`, `5.5.12`, `5.5.13`, `5.5.14`, `5.5.15`, `5.5.16`, `5.5.17`, `5.5.18`, `5.5.19`, `5.5.20`, `5.5.21`, `5.5.22`, `5.5.23`, `5.5.24`, `5.5.25`, `5.5.26`, `5.5.27`, `5.5.28`, `5.5.29`, `5.5.30`, `5.5.31`, `5.5.32`, `5.5.33`, `5.5.34`, `5.5.35`, `5.5.36`, `5.5.37`, `5.5.38`
* Added PHP 5.6 definitions: `5.6snapshot`, `5.6.0`, `5.6.1`, `5.6.2`, `5.6.3`, `5.6.4`, `5.6.5`, `5.6.6`, `5.6.7`, `5.6.8`, `5.6.9`, `5.6.10`, `5.6.11`, `5.6.12`, `5.6.13`, `5.6.14`, `5.6.15`, `5.6.16`, `5.6.17`, `5.6.18`, `5.6.19`, `5.6.20`, `5.6.21`, `5.6.22`, `5.6.23`, `5.6.24`, `5.6.25`, `5.6.26`, `5.6.27`, `5.6.28`, `5.6.29`, `5.6.30`, `5.6.31`, `5.6.32`, `5.6.33`, `5.6.34`, `5.6.35`, `5.6.36`, `5.6.37`, `5.6.38`, `5.6.39`, `5.6.40`
* Added PHP 7.0 definitions: `7.0snapshot`, `7.0.0`, `7.0.1`, `7.0.2`, `7.0.3`, `7.0.4`, `7.0.5`, `7.0.6`, `7.0.7`, `7.0.8`, `7.0.9`, `7.0.10`, `7.0.11`, `7.0.12`, `7.0.13`, `7.0.14`, `7.0.15`, `7.0.16`, `7.0.17`, `7.0.18`, `7.0.19`, `7.0.20`, `7.0.21`, `7.0.22`, `7.0.23`, `7.0.24`, `7.0.25`, `7.0.26`, `7.0.27`, `7.0.28`, `7.0.29`, `7.0.30`, `7.0.31`, `7.0.32`, `7.0.33`
* Added PHP 7.1 definitions: `7.1snapshot`, `7.1.0`, `7.1.1`, `7.1.2`, `7.1.3`, `7.1.4`, `7.1.5`, `7.1.6`, `7.1.7`, `7.1.8`, `7.1.9`, `7.1.10`, `7.1.11`, `7.1.12`, `7.1.13`, `7.1.14`, `7.1.15`, `7.1.16`, `7.1.17`, `7.1.18`, `7.1.19`, `7.1.20`, `7.1.21`, `7.1.22`, `7.1.23`, `7.1.24`, `7.1.25`, `7.1.26`, `7.1.27`, `7.1.28`, `7.1.29`, `7.1.30`, `7.1.31`, `7.1.32`, `7.1.33`
* Added PHP 7.2 definitions: `7.2snapshot`, `7.2.0`, `7.2.1`, `7.2.2`, `7.2.3`, `7.2.4`, `7.2.5`, `7.2.6`, `7.2.7`, `7.2.8`, `7.2.9`, `7.2.10`, `7.2.11`, `7.2.12`, `7.2.13`, `7.2.14`, `7.2.15`, `7.2.16`, `7.2.17`, `7.2.18`, `7.2.19`, `7.2.20`, `7.2.21`, `7.2.22`, `7.2.23`, `7.2.24`, `7.2.25`, `7.2.26`, `7.2.27`, `7.2.28`, `7.2.29`, `7.2.30`, `7.2.31`, `7.2.32`, `7.2.33`, `7.2.34`
* Added PHP 7.3 definitions: `7.3snapshot`, `7.3.0`, `7.3.1`, `7.3.2`, `7.3.3`, `7.3.4`, `7.3.5`, `7.3.6`, `7.3.7`, `7.3.8`, `7.3.9`, `7.3.10`, `7.3.11`, `7.3.12`, `7.3.13`, `7.3.14`, `7.3.15`, `7.3.16`, `7.3.17`, `7.3.18`, `7.3.19`, `7.3.20`, `7.3.21`, `7.3.22`, `7.3.23`, `7.3.24`, `7.3.25`, `7.3.26`, `7.3.27`, `7.3.28`, `7.3.29`, `7.3.30`, `7.3.31`, `7.3.32`, `7.3.33`
* Added PHP 7.4 definition: `7.4snapshot`, `7.4.0`, `7.4.1`, `7.4.2`, `7.4.3`, `7.4.4`, `7.4.5`, `7.4.6`, `7.4.7`, `7.4.8`, `7.4.9`, `7.4.10`, `7.4.11`, `7.4.12`, `7.4.13`, `7.4.14`, `7.4.15`, `7.4.16`, `7.4.18`, `7.4.19`, `7.4.20`, `7.4.21`, `7.4.22`, `7.4.23`, `7.4.24`, `7.4.25`, `7.4.26`, `7.4.27`, `7.4.28`, `7.4.29`, `7.4.30`, `7.4.32`, `7.4.33`
* Added PHP 8.0 definition: `8.0snapshot`, `8.0.0`, `8.0.1`, `8.0.2`, `8.0.3`, `8.0.5`, `8.0.6`, `8.0.7`, `8.0.8`, `8.0.9`, `8.0.10`, `8.0.11`, `8.0.12`, `8.0.13`, `8.0.14`, `8.0.15`, `8.0.16`, `8.0.17`, `8.0.18`, `8.0.19`, `8.0.20`, `8.0.21`, `8.0.22`, `8.0.23`, `8.0.24`, `8.0.25`, `8.0.26`, `8.0.27`, `8.0.28`, `8.0.29`, `8.0.30`
* Added PHP 8.1 definition: `8.1snapshot`, `8.1.0`, `8.1.1`, `8.1.2`, `8.1.3`, `8.1.4`, `8.1.5`, `8.1.6`, `8.1.7`, `8.1.8`, `8.1.9`, `8.1.10`, `8.1.11`, `8.1.12`, `8.1.13`, `8.1.14`, `8.1.15`, `8.1.16`, `8.1.17`, `8.1.18`, `8.1.19`, `8.1.20`, `8.1.21`, `8.1.22`, `8.1.23`, `8.1.24`, `8.1.25`, `8.1.26`, `8.1.27`,`8.1.28`,`8.1.29`,`8.1.30`,`8.1.31`,`8.1.32`
* Added PHP 8.2 definition: `8.2snapshot`, `8.2.0`, `8.2.1`, `8.2.2`, `8.2.3`, `8.2.4`, `8.2.5`, `8.2.6`, `8.2.7`, `8.2.8`, `8.2.9`, `8.2.10`, `8.2.11`, `8.2.12`, `8.2.13`, `8.2.14`, `8.2.15`, `8.2.16`, `8.2.17`,`8.2.18`,`8.2.19`,`8.2.20`,`8.2.21`,`8.2.22`,`8.2.23`,`8.2.24`,`8.2.25`,`8.2.26`,`8.2.27`,`8.2.28`
* Added PHP 8.3 definition: `8.3snapshot`, `8.3.0`, `8.3.1`, `8.3.2`, `8.3.3`, `8.3.4`,`8.3.5`,`8.3.6`,`8.3.7`,`8.3.8`,`8.3.9`,`8.3.10`,`8.3.11`,`8.3.12`,`8.3.13`,`8.3.14`,`8.3.14`,`8.3.15`,`8.3.16`,`8.3.17`,`8.3.18`,`8.3.19`,`8.2.20`
* Added PHP 8.4 definition: `8.4.1`,`8.4.2`,`8.4.3`,`8.4.4`,`8.4.5`,`8.4.6`
* Removed old definitions: `5.3.11RC1`, `5.3.11RC2`, `5.3.19RC1`, `5.3.20RC1`, `5.3.9RC3`, `5.3.9RC4`, `5.3snapshot`, `5.4.0alpha3`, `5.4.0beta1`, `5.4.0beta2`, `5.4.0RC3`, `5.4.0RC3`, `5.4.0RC4`, `5.4.0RC5`, `5.4.0RC6`, `5.4.0RC7`, `5.4.0RC8`, `5.4.10RC1`, `5.4.1RC1`, `5.4.1RC2`, `5.4.9RC1`, `5.5.0alpha1`, `5.5.0alpha2`, `5.5.0alpha3`, `5.5.0alpha4`, `5.5.0alpha5`, `5.5.0alpha6`, `5.5.0beta1`, `5.5.0beta2`, `5.5.0beta3`, `5.5.0beta4`, `5.5.0RC1`, `5.5.0RC2`, `5.5.0RC3`

## 0.10.0 - 2013-06-14

* Add `rbenv-install` for `phpenv` Thanks @hnw
* Add 5.5.0alpha3, 5.5.0alpha4, 5.5.0alpha5, 5.5.0alpha6, 5.5.0beta1, 5.5.0beta2, 5.5.0beta3, 5.5.0beta4
  5.5.0RC1, 5.5.0RC2, 5.5.0RC3 (@loicfrering, @CHH
* Add 5.3.20, 5.3.21, 5.3.22, 5.3.23, 5.3.24, 5.3.25, 5.3.26 @rogeriopradoj, @loicfrering, @CHH
* Add 5.4.11, 5.4.12, 5.4.13, 5.4.14, 5.4.15, 5.4.16 @rogeriopradoj, @loicfrering, @CHH
* Add `PHP_BUILD_ZTS_ENABLE` environment variable to build PHP with ZTS
* Fixed [#118](https://github.com/CHH/php-build/pull/118): Install apache module into user's libexec dir Thanks @hnw
* Fixed [#117](https://github.com/CHH/php-build/pull/117): Use "php-config" instead of "php" to get extension_dir path Thanks @hnw
* Fixed [#116](https://github.com/CHH/php-build/pull/116): Fix extension's path to relative one in apc.ini @hnw
* Fixed [#113](https://github.com/CHH/php-build/pull/113): Find TMP dir based on OS default path @slashmili
* Fixed [#109](https://github.com/CHH/php-build/pull/109): Cannot change config-file-path flag as it's hard coded @CHH

## 0.9.0 - 2013-01-01

* Add XHProf and APC plugins @jtakakura
* Fixed #74 man installation @yuya-takeyama
* Fixed #76 a legibility issue reading the error message @henriquemoody
* Add 5.3.16 and 5.4.6 (@loicfrering)
* Avoid installing PHP executable as "php.DSYM" on OSX 10.7 and 10.8 Thanks @hnw
* Add 5.3.17, 5.4.7 @CHH
* Add `install_package_from_github` for building PHP from Github master @yuya-takeyama
* Add 5.5snapshot @yuya-takeyama
* Add 5.3.18, 5.4.8 (@loicfrering)
* Enable `auto_discover` setting of PEAR by default @CHH
* Run php-build's test suite on Travis CI @rogeriopradoj
* Add 5.3.19RC1, 5.4.9RC1, 5.5.0alpha1 @CHH
* Add 5.3.19, 5.4.9 (@loicfrering)
* Add before-install scripts @usecide
* Add 5.3.20RC1, 5.4.10RC1 @CHH
* Add 5.5.0alpha2 @CHH
* Fixed #99: Add 5.3.20, 5.4.10 @rogeriopradoj

## 0.8.0 - 2012-07-20

 * Added support for 5.3.14, 5.3.15, 5.4.4, 5.4.5 @CHH
 * Fixed Linux support regarding `sed` arguments @hnw
 * Various bug fixes @sanemat, @Milly

## 0.7.0 - 2012-05-25

 * Added support for 5.3.3, 5.3.12, 5.4.2 @loicfrering
 * Commenting out the `extension_dir` in old `php.ini` files so the default extension dir is used. (sanemat)
 * Honor the `--lib-dir` which was defined in the definition file by the user (#61). (grota)
 * Added support for patching releases by separating the download/extract step from the build step (#60). (grota)
 * Updated XDebug in all definitions to `v2.2.0`.
 * Added a `Vagrantfile` for setting up an Ubuntu 10.10 environment for testing php-build.
 * Added a simple automated testing system using [bats](https://github.com/sstephenson/bats) (see `run-tests.sh`). There are 3 configurations:
   - `all`: Builds all builtin definitions and runs the test suite on each of them.
   - `stable`: Builds the most recent versions of the 5.3 and 5.4 series.
   - Supply a definition name and it builds only the definition and runs the test suite on it.

## 0.6.2 - 2012-05-18

 * Fixed bug #57: Automatic enabling of extension does not work with `pecl` command.

## 0.6.1 - 2012-05-09

 * Added support for 5.4.3, 5.3.13

## 0.6.0 - 2012/05/01

 * php-build now works as plugin to [humanshell/phpenv](https://github.com/humanshell/phpenv) @humanshell
 * Added support for 5.4.1, 5.3.11
 * Better handling of `*.dSYM` executables @CHH, @eriksencosta

## 0.5.0 - 2012-04-16

 * Added `--pear` flag to install the good old pear installer alongside of Pyrus.
 * Added 5.4.1RC1, 5.4.1RC2, 5.3.11RC1, and 5.3.11RC2 @loicfrering.
 * Removed a hack which renamed generated debug symbols on OSX.
 * Removed IMAP from enabled extensions.
 * Added experimental `with_apxs2`, which makes an Apache HTTPD module.
 * Fix `install.sh` by removing the unused `LOG_DIR` variable (suin).

## 0.4.0 - 2012-03-04

 * XDebug was updated to 2.1.3 in all `5.2.x` and `5.3.x` definitions.
 * PEAR and Pyrus can be installed along each other. This is experimental though.
 * Added `php-build.5` about the definition file format.
 * A particular revision can be passed to `install_xdebug_master` @loicfrering.
 * Added definition for 5.4.0 final @loicfrering.

## 0.3.0 - 2012-02-19

 * Added 5.3.10, 5.4.0RC7
 * Added 5.4.0RC8 @loicfrering
 * Build Logs are now stored in `/tmp`.
 * Enabled `mbstring` in `5.2.17` @loicfrering
 * Refactored some code in `download` to enable extraction of both `.gz` and `.bz2` archives via `tar`.

## 0.2.0 - 2012-01-31

 * Added 5.4.0RC6 @loicfrering
 * Added `--enable-sockets` to the default configure flags for all builds.

## 0.1.1 - 2012-01-11

 * Added 5.3.9RC4, 5.4.0RC5
 * Some changes to Pyrus setup

## 0.1.0 - 2011-12-28

 * Initial Release

[bats]: https://github.com/sstephenson/bats
