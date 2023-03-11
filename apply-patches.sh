#!/bin/sh

ls -1 $1"/*.patch" | awk '{ print "patch -Np1 < "$1}' | /bin/bash
