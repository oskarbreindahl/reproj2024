#!/bin/bash

# NOTE: This script was used in the early stages of the project to test Pyperformance functionality

# Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <First Python Version> <First Python Path> <Second Python Version> <Second Python Path>"
  exit 1
fi

# Assign the arguments to variables
PYTHON1_VERSION=$1
PYTHON1_PATH=$2
PYTHON2_VERSION=$3
PYTHON2_PATH=$4

# Confirm versions
echo "Benchmarking $PYTHON1_VERSION against $PYTHON2_VERSION."
echo ""

# "> /dev/null 2>&1" is used to obscure irrelevant output
echo "Installing Pyperformance for each version if needed..."
$PYTHON1_VERSION -m pip install pyperformance
$PYTHON2_VERSION -m pip install pyperformance
echo "Done."
echo ""
sleep 1
echo "Running benchmark(s) on each version..."
$PYTHON1_VERSION -m pyperformance run --benchmarks=chaos --python=$PYTHON1_PATH -o $PYTHON1_VERSION.json
$PYTHON2_VERSION -m pyperformance run --benchmarks=chaos --python=$PYTHON2_PATH -o $PYTHON2_VERSION.json
echo "Done."
echo ""
sleep 1
echo "Comparison by benchmark:"
pyperformance compare $PYTHON1_VERSION.json $PYTHON2_VERSION.json
