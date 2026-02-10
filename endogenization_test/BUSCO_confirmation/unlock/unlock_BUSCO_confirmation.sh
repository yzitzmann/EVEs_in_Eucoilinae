#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N unlock_BUSCO_confirmation
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/BUSCO_confirmation

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s BUSCO.sh --unlock --use-conda

# deactivate conda environment
conda deactivate

#submission
# qsub -q fast.q -pe smp 5 unlock_BUSCO_confirmation.sh
