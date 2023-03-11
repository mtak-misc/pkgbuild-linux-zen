#!/bin/sh

_patches=$1"/*.patch"
for _f in "${_patches[@]}"; do
  patch -Np1 < "${_f}"
done
