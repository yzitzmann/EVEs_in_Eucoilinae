#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_phylo_lost_EVEs
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny_lost_EVEs

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s new_phylo.sh --use-conda

# deactivate conda environment
conda deactivate

# submisison
# qsub -q fast.q -pe smp 40 final_new_phylo.sh
