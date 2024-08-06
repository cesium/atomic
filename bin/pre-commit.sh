#!/bin/sh
# pre-commit hook script

set -e  

echo 'Running pipeline...'

mix ci

echo 'Success running pipeline!'
