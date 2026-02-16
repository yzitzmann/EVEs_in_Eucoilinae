#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_phylo

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny

# activate conda environment
conda activate snakemake8-env

# 1. subset for Filamentoviridae EVE cluster
grep "Filamentoviridae" /home/yzitzmann/paper/endogenization_test/EVEs/output/all_EVEs.txt | cut -f 2 | sed 's/(-)//g' | sed 's/(+)//g' | sed 's/-/_/g' | sed 's/:/_/g' > data/Fila_EVEs.txt
grep -f data/Fila_EVEs.txt /home/yzitzmann/paper/phylogenetic_reconstruction/clustering/output/EVE_clusters/EVE_clusters.tsv > data/tmp.tsv
grep -P '(?:[^\t]*\t){2,}' data/tmp.tsv > data/Fila_clusters.tsv
rm data/tmp.tsv

# 2. create cluster_IDs.txt
cut -f 1 data/Fila_clusters.tsv > data/cluster_IDs.txt

# 3. modify input FASTA
sed 's/(-)//g' /home/yzitzmann/paper/phylogenetic_reconstruction/clustering/data/EVE_virus.faa | sed 's/(+)//g' | sed 's/-/_/g' | sed 's/:/_/g' > data/EVE_virus.faa

# 4. snakemake
snakemake --cores $NSLOTS -s phylo.smk --use-conda

# 5. deactivate conda environment
conda deactivate

# submisison
# qsub -q small.q -pe smp 40 final_phylo.sh
