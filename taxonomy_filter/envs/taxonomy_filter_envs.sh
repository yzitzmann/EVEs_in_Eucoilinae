#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N taxonomy_filter_envs
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/taxonomy_filter

# activate conda environment
conda activate snakemake8-env

# snakemake dryrun
snakemake --cores $NSLOTS -s taxonomy_assignment.sh --conda-create-envs-only

# deactivate conda environment
conda deactivate

# submision
# qsub -q small.q -pe smp 5 taxonomy_filter_envs.sh
