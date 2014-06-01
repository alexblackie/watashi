#!/bin/bash

GIT_ROOT=`git rev-parse --show-toplevel`

(
  cd "$GIT_ROOT/www"

  echo "Starting SimpleHTTPServer in `pwd` at 0.0.0.0:8000"
  python -m SimpleHTTPServer 8000
)
