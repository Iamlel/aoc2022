#!/bin/bash

gcc -c $1
gnat bind ${1%.*}
gnat link ${1%.*}

rm ${1%.*}.o ${1%.*}.ali
./${1%.*}
