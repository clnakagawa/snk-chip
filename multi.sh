#!/usr/bin/bash

snakemake -j1 --use-conda --scheduler greedy

echo "between runs"

snakemake -j1 --use-conda --scheduler greedy