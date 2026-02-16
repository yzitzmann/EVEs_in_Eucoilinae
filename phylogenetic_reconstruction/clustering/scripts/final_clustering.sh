#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_clustering

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/phylogenetic_reconstruction/clustering

# 1. run first Snakemake-script
# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s scripts/add_EVEs.smk --use-conda

# deactivate conda environment
conda deactivate

# merge all EVEs and ancestral event Filamentoviridae candidates
cat data/Fila_candidates/*.txt > data/Fila_candidates/all_candidates.txt
cat data/Fila_candidates/all_candidates.txt /home/yzitzmann/paper/endogenization_test/EVEs/output/all_EVEs.txt > data/all_EVEs_and_candidates.txt

# 2. create virus IDs
cut -d ' ' -f 1 data/viral_protein_ivspers_fila_nophages_nopolydna_LbFV_lef5.faa | grep ">" | sed 's/>//g' > data/virus_IDs.txt

# 3. run second Snakemake-script
# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s clustering.smk --use-conda

# deactivate conda environment
conda deactivate

# 4. create cluster IDs
cut -f 1 output/labels_clusters.tsv | sort | uniq > data/cluster_IDs.txt

# 5. run third Snakemake-script
# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s scripts/clusters.smk --use-conda

# deactivate conda environment
conda deactivate

# 6. maintain only EVE-containing clusters
cat output/separate_clusters/*.tsv > output/separate_clusters/all_clusters.tsv
grep "Fi" output/separate_clusters/all_clusters.tsv > output/EVE_clusters/EVE_clusters.tsv

# submisison
# qsub -q fast.q -pe smp 30 final_clustering.sh
