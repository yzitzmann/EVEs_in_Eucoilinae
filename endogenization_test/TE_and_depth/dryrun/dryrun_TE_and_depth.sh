#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N dryrun_TE_and_depth
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/TE_and_depth

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s TE_and_depth.sh -n

# deactivate conda environment
conda deactivate

#submission
# qsub -q fast.q -pe smp 1 dryrun_TE_and_depth.sh

