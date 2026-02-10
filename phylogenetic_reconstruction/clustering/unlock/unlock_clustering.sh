#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N unlock_clustering
#$ -m e

# load modules required
#module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/phylogenetic_reconstruction/clustering

# 1. run first Snakemake-script
# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s add_EVEs.sh --use-conda --unlock

# deactivate conda environment
conda deactivate

# 2. run second Snakemake-script
# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s clustering.sh --use-conda --unlock

# deactivate conda environment
conda deactivate

# 3. run third Snakemake-script
# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s clusters.sh --use-conda --unlock

# deactivate conda environment
conda deactivate

# submisison
# qsub -q fast.q -pe smp 1 unlock_clustering.sh
