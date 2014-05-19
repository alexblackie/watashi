#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`

(
  cd "$GIT_ROOT/www"

  echo "Starting SimpleHTTPServer in `pwd`"
  python -m SimpleHTTPServer 8000
)
