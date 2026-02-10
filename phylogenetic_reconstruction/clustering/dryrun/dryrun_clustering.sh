#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N dryrun_clustering
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/phylogenetic_reconstruction/clustering

# 1. create virus IDs
cut -d ' ' -f 1 data/viral_protein_ivspers_fila_nophages_nopolydna_LbFV_lef5.faa | grep ">" | sed 's/>//g' > data/virus_IDs.txt

# 2. run Snakemake-script
# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s clustering.sh -n --use-conda

# deactivate conda environment
conda deactivate

# submisison
# qsub -q fast.q -pe smp 1 dryrun_clustering.sh

