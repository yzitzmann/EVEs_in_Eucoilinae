#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N create_protein_db
#$ -m be

# load modules required
module load miniforge/24.3.0
 
# data directory
cd /home/yzitzmann/paper/viral_protein_database
 
# activate conda environment (includes seqkit 2.8.2; https://anaconda.org/bioconda/seqkit)
conda activate virus-env

# Downloads
# 1. viral_protein_refseq_release_viral_Apr21_2025.faa       https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/
#       version 2025-03-06
#gzip -d viral_protein_refseq_release_viral_Apr21_2025.faa.gz

# 2. viral_protein_refseq_release_viral_Apr21_2025.gpff     https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/
#       version 2025-03-06

# 3. Download accession numbers of all phage proteins (all NCBI virus sequences which include "phage" in record)
esearch -db protein -query "txid10239[Organism] AND phage[All Fields]" | efetch -format acc > inputs/phages.txt

# 3. Download accession numbers of all Polydnaviriformidae proteins
esearch -db protein -query "txid2946196[Organism] AND refseq[Filter]" | efetch -format acc > inputs/polydnaviriformidae.txt

# 4. Download Filamentoviridae sequences
esearch -db protein -query "PRJNA964713[BioProject]" | efetch -format fasta > inputs/Filamentoviridae.fasta

# 5. Download IVSPER sequences
# Hdidymator_IVSPER1.fasta                          https://www.ncbi.nlm.nih.gov/ipg/?term=GQ923581
# Hdidymator_IVSPER2.fasta                          https://www.ncbi.nlm.nih.gov/ipg/?term=GQ923582
# Hdidymator_IVSPER3.fasta                          https://www.ncbi.nlm.nih.gov/ipg/?term=GQ923583

# Concatenate IVSPERS to single file
cat inputs/Hdidymator_IVSPER1.fasta inputs/Hdidymator_IVSPER2.fasta inputs/Hdidymator_IVSPER3.fasta >> inputs/Hdidymator_IVSPERs.fasta 

# Add IVSPERS and Filamenoviridae to viral protein database
cat inputs/Hdidymator_IVSPERs.fasta inputs/Filamentoviridae.fasta inputs/viral_protein_refseq_release_viral_Apr21_2025.faa  >> outputs/viral_protein_ivspers_fila.faa

# Delete phages from viral protein database
seqkit grep -v -f inputs/phages.txt outputs/viral_protein_ivspers_fila.faa -o outputs/viral_protein_ivspers_fila_nophages.faa

# Delete Polydnaviriformidae from viral protein database
seqkit grep -v -f inputs/polydnaviriformidae.txt outputs/viral_protein_ivspers_fila_nophages.faa -o final/viral_protein_ivspers_fila_nophages_nopolydna.faa

# Deactivate conda environment
conda deactivate
