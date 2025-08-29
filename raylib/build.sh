#!/bin/bash

set -xe
g++ -Wall -Wextra -o main main.cc $(pkg-config raylib --cflags --libs)
./main
