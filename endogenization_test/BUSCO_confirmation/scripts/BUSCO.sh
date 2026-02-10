# Snakemake-script to search BUSCOs in Figitidae genomes and identify EVE candidates occuring on same contigs as BUSCOs

import pandas as pd

# lists
Genome_IDS_table=pd.read_csv("/home/yzitzmann/paper/endogenization_test/BUSCO_confirmation/genome_IDs_table.txt",header=None)
list_Genome_IDs=list(Genome_IDS_table[0])

rule all:
	input:
		expand("output/BUSCO_results/{Genome_ID}/run_hymenoptera_odb12/full_table.tsv", Genome_ID = list_Genome_IDs),
		expand("output/BUSCO_contigs/{Genome_ID}_BUSCO_contigs.txt", Genome_ID = list_Genome_IDs),
		expand("output/EVEs/{Genome_ID}.txt", Genome_ID = list_Genome_IDs)

# search for BUSCOs in genomes
rule BUSCO_search:
	input:
		genomes="/home/yzitzmann/paper/homology_search/genomes/{Genome_ID}.fa"
	output:
		BUSCO="output/BUSCO_results/{Genome_ID}/run_hymenoptera_odb12/full_table.tsv"
	threads:
		5
	conda:
		"envs/busco.yml"
	shell:
		"""
		busco -i {input.genomes} -m genome -l hymenoptera_odb12 -c {threads} -o output/BUSCO_results/{wildcards.Genome_ID} -f
		"""

# filter EVE candidates for those being on the same contig as BUSCOs
rule BUSCO_confirmation:
	input:
		BUSCO_loci="output/BUSCO_results/{Genome_ID}/run_hymenoptera_odb12/full_table.tsv",
		metadata="/home/yzitzmann/paper/TE_filter/output/EVE_candidates/all_candidates.txt"
	output:
		BUSCO_contigs="output/BUSCO_contigs/{Genome_ID}_BUSCO_contigs.txt",
		EVEs="output/EVEs/{Genome_ID}.txt"
	threads:
		3
	shell:
		"""
		# filter busco-search results for contigs with BUSCO hits (complete & fragmented)
		cut -f 3 {input.BUSCO_loci} | sort | uniq | sed '1,2d' > {output.BUSCO_contigs}

		# filter metadata-table for BUSCO-containing contigs in the corresponding genome
		grep -f {output.BUSCO_contigs} {input.metadata} | grep {wildcards.Genome_ID} > {output.EVEs} || true
		"""
