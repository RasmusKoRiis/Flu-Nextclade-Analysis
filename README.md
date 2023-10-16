# Nextflow Flu Clade Analysis

This Nextflow pipeline performs clade analysis for different flu strains using Nextclade.

## Features

Clade Analysis for:
- H1N1pdm HA
- H3N2 HA
- B/Victoria HA


## Dependencies

- Nextflow
- Docker

## Usage

To run the workflow:


nextflow run main.nf --fasta_file=/path/to/your/input.fasta

To test the workflow:

nextflow run main.nf

The test should generate a csv containing two samples (H1 and H3) with clade assignment. 

