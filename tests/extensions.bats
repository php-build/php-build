#!/usr/bin/env bats

@test "Check loaded extensions" {
    run "$TEST_PREFIX/bin/php" -m
    echo "$output" >&2

    echo "$output" | grep -q '^bz2$'
    echo "$output" | grep -q '^curl$'
    echo "$output" | grep -q '^exif$'
    echo "$output" | grep -q '^ftp$'
    echo "$output" | grep -q '^gd$'
    echo "$output" | grep -q '^libxml$'
    echo "$output" | grep -q '^mcrypt$'
    echo "$output" | grep -q '^mbstring$'
    echo "$output" | grep -q '^mysqli$'
    [ "${TEST_PREFIX##*/}" != "5.2.17" ] && echo "$output" | grep -q '^mysqlnd$'
    echo "$output" | grep -q '^openssl$'
    echo "$output" | grep -q '^pcre$'
    echo "$output" | grep -q '^pdo_mysql$'
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
