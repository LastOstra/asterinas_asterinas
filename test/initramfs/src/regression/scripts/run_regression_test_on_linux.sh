#!/bin/sh

# SPDX-License-Identifier: MPL-2.0

set -e

/test/fs/sysfs/device/run_test.sh

echo "All regression tests on Linux passed."
