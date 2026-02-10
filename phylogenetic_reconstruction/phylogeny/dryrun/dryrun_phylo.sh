#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N dryrun_phylo
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny

# activate conda environment
conda activate snakemake8-env

# 1. subset for Filamentoviridae EVE cluster
grep "Filamentoviridae" /home/yzitzmann/paper/endogenization_test/EVEs/output/all_EVEs.txt | cut -f 2 | sed 's/(-)//g' | sed 's/(+)//g' | sed 's/-/_/g' | sed 's/:/_/g' > data/Fila_EVEs.txt
grep -f data/Fila_EVEs.txt data/EVE_clusters.tsv > data/Fila_clusters.tsv

# 2. create cluster_IDs.txt
cut -f 1 data/Fila_clusters.tsv > data/cluster_IDs.txt

# 3. snakemake
snakemake --cores $NSLOTS -s phylo.sh --use-conda -n

# deactivate conda environment
conda deactivate

# submisison
# qsub -q fast.q -pe smp 1 dryrun_phylo.sh
