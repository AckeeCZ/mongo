#!/bin/bash
#set -eo pipefail

echo "Running multiple entrypoints script... "

for a in opt/*.sh

do
    echo "running script $a"
    $a "$@"
done
