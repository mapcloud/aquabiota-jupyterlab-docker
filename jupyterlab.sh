#!/bin/sh
#  exec jupyter lab --ip=* --port=8888 --no-browser --notebook
exec jupyter lab --ip=* --port=8899 --no-browser --allow-root --notebook-dir=/opt/notebooks
