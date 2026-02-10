#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N dryrun_confirmed_EVEs
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/EVEs

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s Filter_confirmed_EVEs.sh -n --use-conda

# deactivate conda environment
conda deactivate

#submission
# qsub -q small.q -pe smp 5 dryrun_confirmed_EVEs.sh

