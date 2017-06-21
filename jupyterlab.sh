#!/bin/sh
#  exec jupyter lab --ip=* --port=8888 --no-browser --notebook-dir=/opt/notebooks
exec jupyter lab --ip=* --port=8899 --allow-root --no-browser --notebook-dir=/opt/notebooks
