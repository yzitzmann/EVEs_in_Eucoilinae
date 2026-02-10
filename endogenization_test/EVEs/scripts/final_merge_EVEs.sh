#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_merge_EVEs
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/EVEs

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s merge_EVEs.sh --use-conda

# deactivate conda environment
conda deactivate

# submission
# qsub -q fast.q -pe smp 5 final_merge_EVEs.sh

