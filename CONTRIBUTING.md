# Contributing to php-build

## Running the tests

php-build uses [Bats] to run tests on built PHP versions.  The script
`run-tests.sh` in the project root builds PHP versions into a temporary
directory and runs the tests.  This script is also capable of compiling a series
of definitions for multiple PHP versions.

The script can be invoked like this:

    % ./run-tests.sh <definition>...

There is also a special target for testing php-build, `stable`.  The `stable`
target tests the latest stable release of the active PHP branches.  At the time
of the writing these are `5.4.9` and `5.3.19`.

## Writing definitions for stable PHP releases

Let's assume a new stable release is out, and it's named `5.5.0`.  First you
will likely use a definition of any of the preview releases of this series as a
base, for example `5.5.0RC1`.

Create a file named `5.5.0` in `share/php-build/definitions`.  Then let's get
the URL for the tarball. Usually tarballs for stable versions are located at
`http://php.net/distributions/php-<version>.tar.bz2`, in our case this would
be `http://php.net/distributions/php-5.5.0.tar.bz2`.

Make sure to always use path ending with `.bz2`, it's the best format that's
supported by php-build.

If there's no [XDebug] release for this new version of PHP, then it
will usually be best to use XDebug from Git by putting `install_xdebug_master`
into the definition.

So far our whole definition will look like this:

    # share/php-build/definitions/5.5.0
    install_package "http://php.net/distributions/php-5.5.0.tar.bz2"
    install_pyrus
    install_xdebug_master # or install_xdebug "<version>"

Since this is a new stable version, let's update the versions for the `stable`
target of the test runner.  Open `run-tests.sh` in your text editor of choice,
and then replace the list of versions in the `STABLE_DEFINITIONS` variable, so
it looks like this:

    STABLE_DEFINITIONS="5.4.10 5.5.0"

Usually two branches of PHP are maintained by the developers, and thus supported
by php-build.  If a `5.5.0` is released, this means that the `stable` target
should test the latest stable `5.4` release, and our `5.5.0` release.

Last but not least, update the [Travis CI] configuration file `.travis.yml`, to
also contain the definitions set as `STABLE_DEFINITIONS`:

    env:
        - DEFINITION=5.4.10
        - DEFINITION=5.5.0

[XDebug]: http://xdebug.org
[Bats]: https://github.com/sstephenson/bats
[Travis CI]: http://travis-ci.org
