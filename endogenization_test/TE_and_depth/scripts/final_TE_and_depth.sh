#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_TE_and_depth
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/TE_and_depth

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s TE_and_depth.sh

# deactivate conda environment
conda deactivate

# submission
# qsub -q fast.q -pe smp 5 final_TE_and_depth.sh

