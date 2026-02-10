#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_metadata
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/metadata/data

## prepare gpff-database
# unzip gz file
cd /home/yzitzmann/paper/metadata/data
#gzip -d viral_protein_refseq_release_viral_Apr21_2025.gpff.gz

# 1. Family data
# Extract version (corresponds to accession number) and family (families either followed by ; or . in file) data
grep -E 'VERSION|dae;|dae\.' viral_protein_refseq_release_viral_Apr21_2025.gpff > Version_families_unfiltered.txt

# Delete all additional taxonomic rows
grep -A 1  "VERSION" Version_families_unfiltered.txt > tmp.txt
grep -A 1  "VERSION" tmp.txt > Version_families.txt

rm tmp.txt Version_families_unfiltered.txt

# Delete all newine characters
cat Version_families.txt | tr -d '\n' > oneline.txt

# insert newline characters before "VERSION"
sed 's/VERSION/\n&/g' oneline.txt > accessions_vFam.txt

rm oneline.txt

# 2. Class data
# Extract versions and class data
grep -E 'VERSION|cetes;|cetes\.' viral_protein_refseq_release_viral_Apr21_2025.gpff > Version_classes_unfiltered.txt

# Delete all additional taxonomic rows
grep -A 1  "VERSION" Version_classes_unfiltered.txt > tmp.txt
grep -A 1  "VERSION" tmp.txt > Version_classes.txt

rm tmp.txt Version_classes_unfiltered.txt

# Delete all newine characters
cat Version_classes.txt | tr -d '\n' > oneline.txt

# insert newline characters before "VERSION"
sed 's/VERSION/\n&/g' oneline.txt > accessions_vCla.txt

rm oneline.txt

# 3. Gather all Filamentoviridae accession numbers
grep ">" /home/yzitzmann/paper/viral_protein_database/inputs/Filamentoviridae.fasta | cut -f 1 -d " " | sed 's/>//g' > fila.acc
grep "Leptopilina boulardi filamentous virus" /home/yzitzmann/paper/viral_protein_database/final/viral_protein_ivspers_fila_nophages_nopolydna_LbFV_lef5.faa | cut -f 1 -d " " | sed 's/>//g' > LbFV.acc
cat fila.acc LbFV.acc > filamentoviridae.acc

# data directory
cd /home/yzitzmann/paper/metadata

# activate conda environment
conda activate snakemake8-env

# snakemake
snakemake --cores $NSLOTS -s metadata.sh --use-conda

# deactivate conda environment
conda deactivate

#submission
# qsub -q small.q -pe smp 20 final_metadata.sh
