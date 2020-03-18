# php-build [![Build Status](https://api.travis-ci.com/php-build/php-build.svg?branch=master)](https://travis-ci.com/php-build/php-build)

php-build is a utility for building versions of PHP to use them side by side with each other. The overall structure is loosly borrowed from Sam Stephenson's [ruby-build].

## Overview

* [Installation](#installation)
* [Contributing](#contributing)
* [Changelog](#changelog)
* [License](#license)

## Installation

### As `phpenv` plugin

#### With [phpenv] via installer

It's the standard way: installs `phpenv` in $HOME/.phpenv (default
$PHPENV_ROOT value).

```shell
curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \
    | bash
```

See more on https://github.com/phpenv/phpenv-installer: install [phpenv](https://github.com/phpenv/phpenv) +
[php-build/php-build](https://github.com/php-build/php-build) (and
other plugins), updating all of them when you want to!

#### With `phpenv` manually

Locate your phpenv directory:

    % ls $HOME/.phpenv

Clone the Git repository into phpenv plugins directory:

    % git clone git://github.com/php-build/php-build.git $HOME/.phpenv/plugins/php-build

Now you can use php-build as phpenv plugin, as follows:

    % phpenv install <definition>

The built version will be installed into `$HOME/.phpenv/versions/<definition>`.

### As standalone `php-build`

Clone the Git Repository:

    % git clone git://github.com/php-build/php-build.git

Then go into the extracted/cloned directory and run:

    % ./install.sh

This installs `php-build` to the default prefix `/usr/local`.

To install php-build to an other location than `/usr/local` set the `PREFIX`
environment variable:

    % PREFIX=$HOME/local ./install.sh

If you don't have permissions to write to the prefix, then you have to run
`install.sh` as superuser, either via `su -c` or via `sudo`.

## Contributing

Issue reports and pull requests are always welcome.

- Freenode channel: `#php-build`
- Google group: https://groups.google.com/forum/#!forum/php-build-developers

All contributions will be reviewed and merged by the core team:

* [Graham Campbell](https://github.com/GrahamCampbell)
* [Rogerio Prado de Jesus](https://github.com/rogeriopradoj)
* [Loïc Frering](https://github.com/loicfrering)
* [Christoph Hochstrasser](https://github.com/CHH)

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

php-build is released under the [MIT License][license].

[license]: LICENSE
[phpenv]: https://github.com/phpenv/phpenv
[ruby-build]: https://github.com/rbenv/ruby-build
