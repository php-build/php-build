# php-build [![Build Status](https://secure.travis-ci.org/php-build/php-build.png?branch=master)](https://travis-ci.org/php-build/php-build)

php-build is a utility for building versions of PHP to use them side by side with each other. The overall structure is loosly borrowed from Sam Stephenson's [ruby-build].

*Do you like php-build? You can buy me a beer by [Gittipp-ing]. Consider also Gittipp-ing one of the awesome [contributors].*

## Overview

* [Installation](#installation)
* [Contributing](#contributing)
* [Changelog](#changelog)
* [License](#license)

## Installation

### Install standalone php-build

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

### Install with [phpenv]

Locate your phpenv directory:

    % ls $HOME/.phpenv

Clone the Git repository into phpenv plugins directory:

    % git clone git://github.com/php-build/php-build.git $HOME/.phpenv/plugins/php-build

Now you can use php-build as phpenv plugin, as follows:

    % phpenv install <definition>

The built version will be installed into `$HOME/.phpenv/versions/<definition>`.

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

[contributors]: https://github.com/php-build/php-build/graphs/contributors
[Gittipp-ing]: http://gittip.com/CHH
[license]: LICENSE
[phpenv]: https://github.com/CHH/phpenv
[ruby-build]: https://github.com/sstephenson/ruby-build
