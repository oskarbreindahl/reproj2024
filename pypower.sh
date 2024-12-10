#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <Python Version> <Python Path>"
  exit 1
fi

# Assign the arguments to variables
PYTHON1_VERSION=$1
PYTHON1_PATH=$2

# Confirm versions
echo "Benchmarking $PYTHON1_VERSION"
echo ""

# "> /dev/null 2>&1" is used to obscure irrelevant output
rm -f $PYTHON1_VERSION.json
echo "Installing Pyperformance for each version if needed..."
$PYTHON1_VERSION -m pip install pyperformance
echo "Done."
echo ""
echo "Running benchmark(s) on each version..."
$PYTHON1_VERSION -m pyperformance run --benchmarks=float --python=$PYTHON1_PATH -o $PYTHON1_VERSION-float.json
echo "Done."
