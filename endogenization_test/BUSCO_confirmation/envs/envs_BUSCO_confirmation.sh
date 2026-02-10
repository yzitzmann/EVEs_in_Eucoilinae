#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N envs_BUSCO_confirmation
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/BUSCO_confirmation

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s BUSCO.sh --conda-create-envs-only

# deactivate conda environment
conda deactivate

#submission
# qsub -q fast.q -pe smp 1 envs_BUSCO_confirmation.sh
