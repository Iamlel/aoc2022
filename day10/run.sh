#!/bin/bash

fpc $1
rm ${1%.*}.o
./${1%.*}
