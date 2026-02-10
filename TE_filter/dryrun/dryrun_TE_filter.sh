#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N dryrun_TE_filter
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/TE_filter2

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s TE_filter.sh --use-conda -n

# deactivate conda environment
#conda deactivate

#submission
# qsub -q fast.q -pe smp 1 dryrun_TE_filter.sh
