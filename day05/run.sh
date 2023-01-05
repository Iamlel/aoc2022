#!/bin/bash

ocamlc $1 -o ${1%.*}

rm ${1%.*}.cmi ${1%.*}.cmo
./${1%.*}
