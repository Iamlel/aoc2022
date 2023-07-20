#!/bin/bash

gfortran -O3 $1 Vector.o -o ${1%.*}

./${1%.*}
rm ./${1%.*}
