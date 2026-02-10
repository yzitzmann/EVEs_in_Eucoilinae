# Snakemake-script to merge BUSCO-, sequencing depth and TE-confirmed EVEs

import pandas as pd

# Genome IDs
Genome_IDS_table=pd.read_csv("/home/yzitzmann/paper/endogenization_test/seq_depth_confirmation/genome_IDs_table.txt",header=None)
list_Genome_IDs=list(Genome_IDS_table[0])

rule all:
	input:
		expand("output/{Genome_ID}.txt", Genome_ID = list_Genome_IDs),
		"output/all_EVEs.txt"

# merge all BUSCO-, depth and TE-confirmed EVEs for every genome
rule merge:
	input:
		BUSCO="/home/yzitzmann/paper/endogenization_test/BUSCO_confirmation/output/EVEs/{Genome_ID}.txt",
		depth="/home/yzitzmann/paper/endogenization_test/seq_depth_confirmation/output/EVEs/{Genome_ID}_depth_EVEs.txt",
		TE="/home/yzitzmann/paper/endogenization_test/TE_and_depth/output/EVEs/{Genome_ID}.txt"
	output:
		all_EVEs="output/{Genome_ID}.txt"
	threads:
		1
	shell:
		"""
		cat {input.BUSCO} {input.depth} {input.TE} | sort | uniq > {output.all_EVEs}
		"""
rule merge_all:
	input:
		BUSCO="/home/yzitzmann/paper/endogenization_test/BUSCO_confirmation/output/EVEs/BUSCO_EVEs.txt",
		depth="/home/yzitzmann/paper/endogenization_test/seq_depth_confirmation/output/EVEs/depth_EVEs.txt",
		TE="/home/yzitzmann/paper/endogenization_test/TE_and_depth/output/EVEs/TE_EVEs.txt"
	output:
		all_EVEs="output/all_EVEs.txt"
	threads:
		1
	shell:
		"""
		cat {input.BUSCO} {input.depth} {input.TE} | sort | uniq > {output.all_EVEs}
		"""
