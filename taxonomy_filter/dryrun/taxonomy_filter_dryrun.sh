#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N taxonomy_filter_dryrun
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/taxonomy_filter

# activate conda environment
conda activate snakemake8-env

# snakemake dryrun
snakemake --cores $NSLOTS -s taxonomy_assignment.sh -n --use-conda

# deactivate conda environment
conda deactivate

# submission
#qsub -q small.q -pe smp 1 taxonomy_filter_dryrun.sh
