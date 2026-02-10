#!/bin/bash
#
#$ -cwd
#$ -S /bin/bash
#$ -j n
#$ -N create_tax_db
#$ -m e

# set working directory
cd /share/pool/databases/nr_db

# download NR as seqTaxDB (download: June 13, 2025)
/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs databases NR /share/pool/databases/nr_db/NR tmp # NR has to be an empty file within nr_db directory

# filter seqTaxDB
/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs filtertaxseqdb NR NR_tmp --taxon-list '!44353' # Figitidae NCBI taxonomy ID: 44353
/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs filtertaxseqdb NR_tmp NR_filtered --taxon-list '!2946196' # PolyDNAviriformide NCBI taxonomy ID:2946196

# create final tax db
/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs createtaxdb NR_filtered tmp

# submission
qsub -q small.q -pe smp 10 create_tax_db.sh
