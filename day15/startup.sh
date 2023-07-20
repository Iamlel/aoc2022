#!/bin/bash

git clone https://github.com/thchang/VectorClass.git

mv ./VectorClass/Vector.f90 ./Vector.f90
rm -rf VectorClass

gfortran -c Vector.f90
