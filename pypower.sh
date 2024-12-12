#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <Python Version> <Python Path> <Run number>"
  exit 1
fi

# Assign the arguments to variables
PYTHON1_VERSION=$1
PYTHON1_PATH=$2
RUN_NUMBER=$3

# Confirm versions
echo "Benchmarking $PYTHON1_VERSION"
echo ""

# "> /dev/null 2>&1" is used to obscure irrelevant output
# echo "Installing Pyperformance for each version if needed..."
# $PYTHON1_VERSION -m pip install pyperformance
# echo "Done."
# echo ""
echo "Running benchmark(s) on each version..."
$PYTHON1_VERSION -m pyperformance run --benchmarks=mako --python=$PYTHON1_PATH -o $PYTHON1_VERSION-mako$RUN_NUMBER.json
echo "Done."
