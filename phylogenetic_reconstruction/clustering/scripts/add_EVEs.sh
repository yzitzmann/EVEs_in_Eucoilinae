# Snakemake script to add ancestral event candidates to EVEs to check if they are also endogenized

import pandas as pd

# wildcard lists
Genome_IDS_table=pd.read_csv("/home/yzitzmann/paper/phylogenetic_reconstruction/clustering/data/Genome_IDs.txt",header=None)
list_Genome_IDs=list(Genome_IDS_table[0])

Virus_IDS_table=pd.read_csv("/home/yzitzmann/paper/phylogenetic_reconstruction/clustering/data/fila_candidates_IDs.txt",header=None)
list_Virus_IDs=list(Virus_IDS_table[0])

rule all:
	input:
		expand("data/Fila_candidates/{Genome_ID}__{virus_ID}.txt", Genome_ID=list_Genome_IDs, virus_ID=list_Virus_IDs)

# add ancestral event candidates to EVEs
rule add_EVEs:
        input:
                EVEs="/home/yzitzmann/paper/TE_filter/output/EVE_candidates/{Genome_ID}_candidates.txt"
        output:
                EVEs="data/Fila_candidates/{Genome_ID}__{virus_ID}.txt"
        threads:
                1
        shell:
                """
                grep "{wildcards.virus_ID}" {input.EVEs} > {output.EVEs} || true
                """
