# php-build changelog

## 0.10.0 - 2013/06/14

* Add `rbenv-install` for `phpenv` ([hnw])
* Add 5.5.0alpha3, 5.5.0alpha4, 5.5.0alpha5, 5.5.0alpha6, 5.5.0beta1, 5.5.0beta2, 5.5.0beta3, 5.5.0beta4
  5.5.0RC1, 5.5.0RC2, 5.5.0RC3 ([loicfrering], [CHH])
* Add 5.3.20, 5.3.21, 5.3.22, 5.3.23, 5.3.24, 5.3.25, 5.3.26 ([rogeriopradoj], [loicfrering], [CHH])
* Add 5.4.11, 5.4.12, 5.4.13, 5.4.14, 5.4.15, 5.4.16 ([rogeriopradoj], [loicfrering], [CHH])
* Add `PHP_BUILD_ZTS_ENABLE` environment variable to build PHP with ZTS
* Fixed [#118](https://github.com/CHH/php-build/pull/118): Install apache module into user's libexec dir ([hnw])
* Fixed [#117](https://github.com/CHH/php-build/pull/117): Use "php-config" instead of "php" to get extension_dir path ([hnw])
* Fixed [#116](https://github.com/CHH/php-build/pull/116): Fix extension's path to relative one in apc.ini ([hnw])
* Fixed [#113](https://github.com/CHH/php-build/pull/113): Find TMP dir based on OS default path ([slashmili])
* Fixed [#109](https://github.com/CHH/php-build/pull/109): Cannot change config-file-path flag as it's hard coded ([CHH])

## 0.9.0 - 2013/01/01

* Add XHProf and APC plugins ([jtakakura])
* #74: Fix man installation ([yuya-takeyama])
* #76: Fixed a legibility issue reading the error message
  ([henriquemoody])
* Add 5.3.16 and 5.4.6 ([loicfrering])
* Avoid installing PHP executable as "php.DSYM" on OSX 10.7 and 10.8
  ([hnw])
* Add 5.3.17, 5.4.7 ([CHH])
* Add `install_package_from_github` for building PHP from Github master
  ([yuya-takeyama])
* Add 5.5snapshot ([yuya-takeyama])
* Add 5.3.18, 5.4.8 ([loicfrering])
* Enable `auto_discover` setting of PEAR by default ([CHH])
* Run php-build's test suite on Travis CI ([rogeriopradoj])
* Add 5.3.19RC1, 5.4.9RC1, 5.5.0alpha1 ([CHH])
* Add 5.3.19, 5.4.9 ([loicfrering])
* Add before-install scripts ([usecide])
* Add 5.3.20RC1, 5.4.10RC1 ([CHH])
* Add 5.5.0alpha2 ([CHH])
* #99: Add 5.3.20, 5.4.10 ([rogeriopradoj])

## 0.8.0 - 2012/07/20

 * Added support for 5.3.14, 5.3.15, 5.4.4, 5.4.5 (CHH)
 * Fixed Linux support regarding `sed` arguments (hnw)
 * Various bug fixes (sanemat, Milly)

## 0.7.0 - 2012/05/25

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
 * Added a simple automated testing system using [bats] (see
   `run-tests.sh`). There are 3 configurations:
   * `all`: Builds all builtin definitions and runs the test suite on
     each of them.
   * `stable`: Builds the most recent versions of the 5.3 and 5.4
     series.
   * Supply a definition name and it builds only the definition and runs
     the test suite on it.

[bats]: https://github.com/sstephenson/bats

## 0.6.2 - 2012/05/18

 * Fixed bug #57: Automatic enabling of extension does not work with
   `pecl` command.

## 0.6.1 - 2012/05/09

 * Added support for 5.4.3, 5.3.13

## 0.6.0 - 2012/05/01

 * php-build now works as plugin to
   [humanshell/phpenv](http://github.com/humanshell/phpenv)
(humanshell).
 * Added support for 5.4.1, 5.3.11
 * Better handling of `*.dSYM` executables (CHH, eriksencosta).

## 0.5.0 - 2012/04/16

 * Added `--pear` flag to install the good old pear installer alongside
   of Pyrus.
 * Added 5.4.1RC1, 5.4.1RC2, 5.3.11RC1, and 5.3.11RC2 (loicfrering).
 * Removed a hack which renamed generated debug symbols on OSX.
 * Removed IMAP from enabled extensions.
 * Added experimental `with_apxs2`, which makes an Apache HTTPD module.
 * Fix `install.sh` by removing the unused `LOG_DIR` variable (suin).

## 0.4.0 - 2012/03/04

 * XDebug was updated to 2.1.3 in all `5.2.x` and `5.3.x` definitions.
 * PEAR and Pyrus can be installed along each other. This is
   experimental though.
 * Added `php-build.5` about the definition file format.
 * A particular revision can be passed to `install_xdebug_master`
   (loicfrering).
 * Added definition for 5.4.0 final (loicfrering).

## 0.3.0 - 2012/02/19

 * Added 5.3.10, 5.4.0RC7
 * Added 5.4.0RC8 (loicfrering)
 * Build Logs are now stored in `/tmp`.
 * Enabled `mbstring` in `5.2.17` (loicfrering)
 * Refactored some code in `download` to enable extraction of both
   `.gz` and `.bz2` archives via `tar`.

## 0.2.0 - 2012/01/31

 * Added 5.4.0RC6 (loicfrering)
 * Added `--enable-sockets` to the default configure flags for all
   builds.

## 0.1.1 - 2012/01/11

 * Added 5.3.9RC4, 5.4.0RC5
 * Some changes to Pyrus setup

## 0.1.0 - 2011/12/28

 * Initial Release

[jtakakura]: http://github.com/jtakakura
[CHH]: http://github.com/CHH
[yuya-takeyama]: http://github.com/yuya-takeyama
[henriquemoody]: http://github.com/henriquemoody
[rogeriopradoj]: http://github.com/rogeriopradoj
[loicfrering]: http://github.com/loicfrering
[usecide]: http://github.com/usecide
[hnw]: http://github.com/hnw
[slashmili]: https://github.com/slashmili
