#!/usr/bin/env bats

@test "Patches are applied" {
    TIME="$(date "+%Y%m%d%H%M%S")"
    PATCH_TEST_DIR="/tmp/php-build-test-patch-$TIME"
    FILE_TO_PATCH="$PATCH_TEST_DIR/file_to_patch"

    # create test directory
    mkdir $PATCH_TEST_DIR

    # definition file
    echo -e "patch_file \"$PATCH_TEST_DIR/test.patch\"\napply_patches \"$PATCH_TEST_DIR\""\
        > "$PATCH_TEST_DIR/definition_file"

    # the file which should be patched
    echo 'before patch' > "$FILE_TO_PATCH"

    # create the patch file
    echo -e "--- a/file_to_patch\n+++ b/file_to_patch\n@@ -1 +1 @@\n-before patch\n+patched\n"\
        > "$PATCH_TEST_DIR/test.patch"

    ./bin/php-build "$PATCH_TEST_DIR/definition_file" "$PATCH_TEST_DIR/build"

    grep -e "patched" "$FILE_TO_PATCH"

    rm -rf "$PATCH_TEST_DIR"
}
