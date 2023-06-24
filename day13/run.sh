#!/bin/bash

sbcl --noinform --eval "(compile-file \"$1\")" --eval "(quit)" > /dev/null
sbcl --noinform --load "${1%.*}.fasl" --quit --end-toplevel-options "$@"

rm ${1%.*}.fasl
