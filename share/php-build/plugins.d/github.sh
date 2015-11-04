#!/usr/bin/env bash

# Downloads a PHP Source Tarball from GitHub and extracts it to
# `${TMP}/source/${DEFINITION}`.
function download_from_github() {
    local branch=${1}
    local repository_name=${2}
    local package_file="${TMP}/packages/${branch}.tar.gz"
    local package_url="https://github.com/${repository_name}/tarball/${branch}"
    local package_temporary="${TMP}/${branch}.tar.gz"

    if [ -d "${TMP}/source/${DEFINITION}" ]; then
        log "Removing" "Already downloaded and extracted ${package_url}"
        rm -rf "${TMP}/source/${DEFINITION}"
    fi

    log "Downloading" "${package_url}"

    # Remove the temp file if one exists.
    if [ -f "${package_temporary}" ]; then
        rm "${package_temporary}"
    fi

    http get "${package_url}" > ${package_temporary}
    cp "${package_temporary}" "${TMP}/packages"
    rm "${package_temporary}"

    mkdir "${TMP}/source/${DEFINITION}"

    extract_gz "${package_file}" "${TMP}/source/${DEFINITION}"
}

# ### clone_from_github
# Clones a source from GitHub and extracts it to `${TMP}/source/${DEFINITION}`.
function clone_from_github() {
    local branch=${1}
    local repository_name=${2}
    local repository_url="git://github.com/${repository_name}.git"
    local directory="${TMP}/source/${DEFINITION}"

    if [ -d "${directory}" ]; then
        log "Removing" "Already cloned branch ${branch} from ${repository_url}"
        rm -rf "${directory}"
    fi

    log "Cloning" "Branch ${branch} from ${repository_url}"

    git clone --branch=${branch} --depth=1 --quiet --recursive ${repository_url} "${directory}" 2>&4
}

# ### install_package_from_github
#
# Clones and builds the PHP tarball from the given branch/tag on GitHub.
# Optionally, repository canbe specified as 2nd argument.
# Otherwise "php/php-src" is used by default.
function install_package_from_github() {
    local branch=${1}
    local repository_name=${2:-php/php-src}

    {
        clone_from_github ${branch} ${repository_name}
        cd "${TMP}/source/${DEFINITION}"
        build_package
        cd - > /dev/null
    } >&4 2>&1
}
