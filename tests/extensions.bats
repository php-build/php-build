#!/usr/bin/env bats

@test "Check loaded extensions" {
    run "$TEST_PREFIX/bin/php" -m
    echo "$output" >&2

    echo "$output" | grep -q '^bz2$'
    echo "$output" | grep -q '^curl$'
    echo "$output" | grep -q '^exif$'
    echo "$output" | grep -q '^ftp$'
    echo "$output" | grep -q '^gd$'
    # intl is introduced since PHP 5.3.0
    [[ $PHP_MINOR_VERSION > 5.2 ]] && echo "$output" | grep -q '^intl$'
    echo "$output" | grep -q '^libxml$'
    # mcrypt is removed from the core in PHP 7.2.0
    [[ $PHP_MINOR_VERSION < 7.2 ]] && echo "$output" | grep -q '^mcrypt$'
    echo "$output" | grep -q '^mbstring$'
    # avoid long build
    if [[ -z "$TRAVIS" ]] || [[ $PHP_MINOR_VERSION > 5.2 ]]; then
      echo "$output" | grep -q '^mysqli$'
      echo "$output" | grep -q '^pdo_mysql$'
    fi
    # mysqlnd is introduced since PHP 5.3.0
    [[ $PHP_MINOR_VERSION > 5.2 ]] && echo "$output" | grep -q '^mysqlnd$'
    echo "$output" | grep -q '^openssl$'
    echo "$output" | grep -q '^pcre$'
    echo "$output" | grep -q '^pdo_sqlite$'
    echo "$output" | grep -q '^soap$'
    echo "$output" | grep -q '^tidy$'
    echo "$output" | grep -q '^xml$'
    echo "$output" | grep -q '^xmlreader$'
    echo "$output" | grep -q '^xmlrpc$'
    echo "$output" | grep -q '^xsl$'
    echo "$output" | grep -q '^zip$'
    echo "$output" | grep -q '^zlib$'
}
