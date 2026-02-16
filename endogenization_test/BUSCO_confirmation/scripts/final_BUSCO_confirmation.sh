#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_BUSCO_confirmation

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/BUSCO_confirmation

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s BUSCO.smk --use-conda

# deactivate conda environment
conda deactivate

# submission
# qsub -q small.q -pe smp 30 final_BUSCO_confirmation.sh
