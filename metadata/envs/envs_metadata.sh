#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N envs_metadata
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/metadata

# activate conda environment
conda activate snakemake8-env

# snakemake dryrun
snakemake --cores $NSLOTS -s table.sh --conda-create-envs-only --use-conda

# deactivate conda environment
conda deactivate

# submision
# qsub -q fast.q -pe smp 1 envs_metadata.sh
