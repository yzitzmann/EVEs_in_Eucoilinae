#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N homology_search
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/homology_search

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s Viral_homology.sh --use-conda

# deactivate conda environment
conda deactivate

# submission
# qsub -q small.q -pe smp 30 homology_search.sh
