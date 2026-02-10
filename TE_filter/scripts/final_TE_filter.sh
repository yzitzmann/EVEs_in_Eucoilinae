#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_TE_filter
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/TE_filter/data

# download RepeatPeps
#wget https://www.dfam.org/releases/current/families/RepeatPeps.lib.gz
#wget https://www.dfam.org/releases/current/families/RepeatPeps.lib.gz.md5
#gunzip RepeatPeps.lib.gz

# data directory
cd /home/yzitzmann/paper/TE_filter

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s TE_filter.sh --use-conda

# deactivate conda environment
conda deactivate

# submission
# qsub -q small.q -pe smp 40 final_TE_filter.sh
