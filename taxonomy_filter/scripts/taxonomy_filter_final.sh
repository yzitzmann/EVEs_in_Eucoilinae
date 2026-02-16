#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N taxonomy_filter_final

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/taxonomy_filter

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s taxonomy_assignment.smk --use-conda --use-envmodules

# deactivate conda environment
conda deactivate

# submisison
# qsub -q small.q -pe smp 40 taxonomy_filter_final.sh
