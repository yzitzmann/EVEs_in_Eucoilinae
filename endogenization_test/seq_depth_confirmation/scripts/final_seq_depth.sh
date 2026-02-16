#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_seq_depth

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/endogenization_test/seq_depth_confirmation

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s seq_depth.smk --use-conda

# deactivate conda environment
conda deactivate

# submission
# qsub -q fast.q -pe smp 30 final_seq_depth.sh
