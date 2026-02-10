# Snakemake-script to search for EVE candidates in Figitidae genomes, merge overlapping hits and extract EVE candidate sequences

import pandas as pd
import re
import os

# software
mmseqs2="/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs"

# list of genomes 
Genome_IDs_table=pd.read_csv("/home/yzitzmann/paper/homology_search/genome_IDs_table.txt",header=None)
list_Genome_IDs=list(Genome_IDs_table[0])

rule all:
        input:
                "data/viral_protein_ivspers_fila_nophages_nopolydna_LbFVlef5",
                expand("output/mmseqs2/{Genome_ID}/result_mmseqs2.m8", Genome_ID = list_Genome_IDs),
                expand("output/merged_loci/{Genome_ID}_mmseqs_hits_merged.bed", Genome_ID = list_Genome_IDs),
                expand("output/loci/{Genome_ID}_viral_loci.fna", Genome_ID = list_Genome_IDs),
                expand("output/loci/{Genome_ID}_viral_loci.faa", Genome_ID = list_Genome_IDs)

# create the virus protein database
rule Create_viral_db:
        input:
                Viraldb="data/viral_protein_ivspers_fila_nophages_nopolydna_LbFVlef5.faa"
        output:
                Viral_mmseqs2_db="data/viral_protein_ivspers_fila_nophages_nopolydna_LbFVlef5"
        
        threads:
                1

        shell:
                """
                {mmseqs2} createdb {input.Viraldb} {output.Viral_mmseqs2_db}
                """

# search for hits in the genomes (queries) against the virus proteins (targets) with BlastX (Mmseqs2)
rule Homology_analysis:
        input:
                Viraldb="data/viral_protein_ivspers_fila_nophages_nopolydna_LbFVlef5",
                Genomedb="genomes/{Genome_ID}.fa"
        output:
                out="output/mmseqs2/{Genome_ID}/result_mmseqs2.m8"
        
        threads:
                10

        shell:
                """
                #Create a directory where the BlastX results will be written
                mkdir -p output/mmseqs2/{wildcards.Genome_ID}/

                #Create the query database (for each query genome/sequence)
                {mmseqs2} createdb {input.Genomedb} output/mmseqs2/{wildcards.Genome_ID}/{wildcards.Genome_ID}_mmseqs2_db

                #Run Mmseqs2 search (BlastX equivalent, homology search between query and db)
                {mmseqs2} search output/mmseqs2/{wildcards.Genome_ID}/{wildcards.Genome_ID}_mmseqs2_db {input.Viraldb} output/mmseqs2/{wildcards.Genome_ID}/result_mmseqs2 output/mmseqs2/{wildcards.Genome_ID}/tpm -a -s 7.5 -c 0.3 --min-seq-id 0.2 -e 0.002 --threads {threads} --remove-tmp-files

                #From the previous step you get one result file per thread, the next step will format the result column and also put together all the results in one file:
                {mmseqs2} convertalis --format-output 'query,qlen,tlen,target,qstart,qend,qframe,tstart,tend,evalue,tcov,pident,alnlen,mismatch,gapopen,bits,qaln' output/mmseqs2/{wildcards.Genome_ID}/{wildcards.Genome_ID}_mmseqs2_db {input.Viraldb} output/mmseqs2/{wildcards.Genome_ID}/result_mmseqs2 {output.out}
                """

# merge overlapping hits with GenomicRanges (R)
rule Define_loci:
        input:
                all_sense="output/mmseqs2/{Genome_ID}/result_mmseqs2.m8"
        output:
                out="output/merged_loci/{Genome_ID}_mmseqs_hits_merged.bed"
        threads:
                3

        conda:
                "envs/R.yml"

        script:
                "scripts/merge_loci.R"

#Extract candidates loci based on their coordinates on genomes
rule Extract_translate_loci:
        input:
                Bed="output/merged_loci/{Genome_ID}_mmseqs_hits_merged.bed",
                Genome="genomes/{Genome_ID}.fa"
        output:
                Loci_dna="output/loci/{Genome_ID}_viral_loci.fna",
                Loci_aa="output/loci/{Genome_ID}_viral_loci.faa"
        threads:
                2
        
        conda:
                "envs/python.yml"

        shell:
                """
                #Python script that extracts sequence from candidate loci coordinates and translate it into aa
                python3 scripts/Extract_and_translate_loci.py -g {input.Genome} -b {input.Bed} -aa {output.Loci_aa} -dna {output.Loci_dna} -sp {wildcards.Genome_ID}
                
                #Put all loci Fasta sequences into one unique file
                cat {output.Loci_aa} >> output/loci/All_fasta_viral_loci.faa
                cat {output.Loci_dna} >> output/loci/All_fasta_viral_loci.fna
		"""
