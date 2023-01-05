#!/bin/bash
cobc -xO $1
./${1%.*}
