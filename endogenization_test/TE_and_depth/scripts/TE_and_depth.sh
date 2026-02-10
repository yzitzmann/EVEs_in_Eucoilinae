# Snakemake-script to confirm EVEs by TE + depth criterion

import pandas as pd

# Genome IDs
Genome_IDS_table=pd.read_csv("/home/yzitzmann/paper/endogenization_test/seq_depth_confirmation/genome_IDs_table.txt",header=None)
list_Genome_IDs=list(Genome_IDS_table[0])

rule all:
	input:
		expand("output/EVE_contigs/{Genome_ID}.txt", Genome_ID = list_Genome_IDs),
		expand("output/EVEs/{Genome_ID}.txt", Genome_ID = list_Genome_IDs)

# confirm EVEs by checking if candidate has transposable element (TE) on same contig and has sequencing depth ranging within BUSCO distribution
rule confirm_EVEs:
	input:
		depth_contigs="/home/yzitzmann/paper/endogenization_test/seq_depth_confirmation/output/EVE_contigs/{Genome_ID}_5_95.txt",
		TE_contigs="/home/yzitzmann/paper/TE_filter/output/mmseqs2/{Genome_ID}/result_mmseqs2.m8"
	output:
		depth_contigs="output/depth_contigs/{Genome_ID}.txt",
		TE_contigs="output/TE_contigs/{Genome_ID}.txt",
		EVE_contigs="output/EVE_contigs/{Genome_ID}.txt"
	threads:
		1
	shell:
		"""
		mkdir -p output/depth_contigs
		mkdir -p output/TE_contigs
		mkdir -p output/EVE_contigs
		
		cut -f 1 {input.depth_contigs} > {output.depth_contigs}
		cut -f 1 {input.TE_contigs} | sort | uniq > {output.TE_contigs}
		grep -wf {output.depth_contigs} {output.TE_contigs} > {output.EVE_contigs} || true
		"""

rule gather_EVEs:
	input:
		EVE_contigs="output/EVE_contigs/{Genome_ID}.txt",
		metadata="/home/yzitzmann/paper/TE_filter/output/EVE_candidates/all_candidates.txt"
	output:
		EVEs="output/EVEs/{Genome_ID}.txt"
	threads:
		1
	shell:
		"""
		 grep -f {input.EVE_contigs} {input.metadata} | grep {wildcards.Genome_ID} > {output.EVEs} || true
		""" 
