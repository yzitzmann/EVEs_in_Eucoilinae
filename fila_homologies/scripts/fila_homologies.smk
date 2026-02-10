import pandas as pd
import re
import os

#Your softs
mmseqs2="/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs"

#List of all names regrouped 
Genome_IDs_table=pd.read_csv("/home/yzitzmann/paper/fila_homologies/genome_IDs_table.txt",header=None)
list_Genome_IDs=list(Genome_IDs_table[0])

rule all:
        input:
                "data/complete_Filamentoviridae",
                expand("output/mmseqs2/{Genome_ID}/result_mmseqs2.m8", Genome_ID = list_Genome_IDs),
                expand("output/merged_loci/{Genome_ID}_mmseqs_hits_merged.bed", Genome_ID = list_Genome_IDs)

# create the virus protein database
rule Create_viral_db:
        input:
                Viraldb="data/complete_Filamentoviridae.fasta"
        output:
                Viral_mmseqs2_db="data/complete_Filamentoviridae"
        threads:
                1
        shell:
                """
                {mmseqs2} createdb {input.Viraldb} {output.Viral_mmseqs2_db}
                """

# search for hits in the genomes (queries) against the virus proteins (targets) with BlastX (Mmseqs2)
rule Homology_analysis:
        input:
                Viraldb="data/complete_Filamentoviridae",
                Genomedb="/home/yzitzmann/paper/homology_search/genomes/{Genome_ID}.fa"
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
                {mmseqs2} search output/mmseqs2/{wildcards.Genome_ID}/{wildcards.Genome_ID}_mmseqs2_db {input.Viraldb} output/mmseqs2/{wildcards.Genome_ID}/result_mmseqs2 output/mmseqs2/{wildcards.Genome_ID}/tpm -a -s 7.5 -c 0.7 --min-seq-id 0.25 -e 0.001 --threads {threads} --remove-tmp-files

                #From the previous step you get one result file per thread, the next step will format the result column and also put together all the results in one file:
                {mmseqs2} convertalis --format-output 'query,qlen,tlen,target,qstart,qend,qframe,tstart,tend,evalue,tcov,pident,alnlen,mismatch,gapopen,bits,qaln' output/mmseqs2/{wildcards.Genome_ID}/{wildcards.Genome_ID}_mmseqs2_db {input.Viraldb} output/mmseqs2/{wildcards.Genome_ID}/result_mmseqs2 {output.out}
                """

# merge overlapping hits with GenomicRanges using the script merge_loci.R 
rule Define_loci:
        input:
                all_sense="output/mmseqs2/{Genome_ID}/result_mmseqs2.m8"
        output:
                out="output/merged_loci/{Genome_ID}_mmseqs_hits_merged.bed"
        threads:
                3
        conda:
                "envs/C_longula.yml"
        script:
                "scripts/merge_loci.R"
