# Snakemake-script to filter all homology search hits for those with a virus as most recent common ancestor 

import pandas as pd
import re
import os

#software
mmseqs2="/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs" 

rule all:
        input:
                "output/_lca.tsv",
                "output/filtered_loci/candidate_loci.fna",
                "output/filtered_loci/candidate_loci.faa"

# compute most recent common ancestor
rule taxonomy_filter:
        input:
                Loci="/home/yzitzmann/paper/homology_search/strict_params_output/loci/All_fasta_viral_loci.faa",
                Database="/share/pool/databases/nr_db/NR_filtered"
        output:
                report="output/_lca.tsv"
        
        threads:
                40
 
        shell:
                """
                {mmseqs2} easy-taxonomy {input.Loci} {input.Database} output/ output/tmp_files --tax-lineage 1 --lca-mode 4 -s 7.5 -e 0.0001 --threads {threads}
                """

# obtain EVE candidates with viral most recent common ancestor
rule filter_loci:
        input:
                report="output/_lca.tsv",
                Fasta_aa="/home/yzitzmann/paper/homology_search/strict_params_output/loci/All_fasta_viral_loci.faa",
                Fasta_nt="/home/yzitzmann/paper/homology_search/strict_params_output/loci/All_fasta_viral_loci.fna"
        output:
                Filtered_aa="output/filtered_loci/candidate_loci.faa",
                Filtered_nt="output/filtered_loci/candidate_loci.fna"
        
        conda:
                "envs/seqkit.yml"

        threads:
                2
        
        shell:
                """
                # retrieve loci assigned to viruses
                cat {input.report}  | cut -f1,4 | grep "virus" | cut -f1 > output/virus_loci.txt

                # obtain amino acid sequences of loci
                seqkit grep -f output/virus_loci.txt {input.Fasta_aa} > {output.Filtered_aa}
                
		# obtain nucleotide sequences of loci
                seqkit grep -f output/virus_loci.txt {input.Fasta_nt} > {output.Filtered_nt}
                """
