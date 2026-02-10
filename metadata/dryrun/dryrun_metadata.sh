#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N dryrun_metadata
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/metadata

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s table.sh -n --use-conda

# deactivate conda environment
conda deactivate

#submission
# qsub -q fast.q -pe smp 5 dryrun_metadata.sh
