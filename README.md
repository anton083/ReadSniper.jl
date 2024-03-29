# ReadSniper

[![Build Status](https://github.com/Periareion/ReadSniper.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Periareion/ReadSniper.jl/actions/workflows/CI.yml?query=branch%3Amaster)

ReadSniper is a lightweight and (arguably) efficient Julia package designed for mining metagenomic datasets for specific sequences. It is particularly useful for identifying novel or unclassified virus sequences in large-scale genomic data. The package works by rapidly searching for k-mer matches between a reference genome and the reads in a dataset, enabling quick identification of similar sequences even in the presence of mutations.

## Features
- Simple search using k-mer matching and a specialized longest increasing subsequence algorithm
- Customizable k-value for k-mer search, with optimal performance at with a $k$-value of $7$ or $9$

## Installation
To install ReadSniper, simply add the package using Julia's package manager:
```julia
using Pkg; Pkg.add(url="https://github.com/Periareion/ReadSniper.jl.git")
```

## Usage
To use ReadSniper, you will need to provide a reference genome in FASTA format and a metagenomic dataset containing reads in FASTA format (FASTQ format will eventually be supported). Use the `snipe_reads` function to search for sequences similar to the reference genome.

## Limitations and Future Improvements
- Currently suitable for datasets with high percentage identity (pident) RdRp matches (>90%)
- Performance may be slower with lower k-values due to increased number of k-mer matches
- Further comparison with other tools like BLAST and NextGenMap is necessary to fully assess the viability of ReadSniper
- Integration with other Julia packages, such as de novo genome assembly packages, could create a more streamlined workflow

## Contributing
Contributions to ReadSniper are welcome! Please feel free to open issues or submit pull requests for bug fixes, improvements, or new features. If you have any questions, please don't hesitate to reach out.
