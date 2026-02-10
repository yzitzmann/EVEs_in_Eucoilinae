#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N final_fila_homologies
#$ -m e

# load modules required
module load miniforge/24.3.0

# data directory
cd /home/yzitzmann/paper/fila_homologies

# activate conda environment
conda activate snakemake8-env

# download LbFV sequences and create complete Filamentoviridae database
esearch -db protein -query "txid552509[Organism] AND refseq[Filter]" | efetch -format fasta > data/LbFV.fasta
cat data/LbFV.fasta data/Filamentoviridae.fasta > data/complete_Filamentoviridae.fasta

# snakemake
snakemake --cores $NSLOTS -s fila_homologies.sh --use-conda

# deactivate conda environment
conda deactivate

#submission
# qsub -q small.q -pe smp 30 final_fila_homologies.sh
