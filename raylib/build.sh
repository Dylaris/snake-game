#!/bin/sh

set -xe

g++ -o main main.cc                               \
    -Wall -Wextra -Wno-missing-field-initializers \
    -ggdb                                         \
    -I./raylib-5.5_linux_amd64/include            \
    -L./raylib-5.5_linux_amd64/lib -lraylib       \
    -Wl,-rpath=./raylib-5.5_linux_amd64/lib
