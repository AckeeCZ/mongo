#!/bin/bash
set -eo pipefail

echo "Running multiple entrypoints script... "

for a in /opt/*
do
    echo "running script $a"
    $a "$@"
done
