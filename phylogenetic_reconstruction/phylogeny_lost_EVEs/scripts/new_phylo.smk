# Snakemake script to infer the phylogeny of Filamentoviridae EVEs

import pandas as pd

# wildcards
cluster_IDs_table=pd.read_csv("/home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny_lost_EVEs/data/cluster_IDs.txt",header=None)
list_cluster_IDs=list(cluster_IDs_table[0])

rule all:
	input:
		"output/blast/orf108.tbl",
		"output/blast/orf108.txt",
		"output/blast/orf108.faa",
		expand("output/alignment/{cluster_IDs}.fas", cluster_IDs = list_cluster_IDs),
		expand("output/phylogeny/{cluster_IDs}.logs", cluster_IDs = list_cluster_IDs)

rule blast:
	input:
		cluster="data/FASTA/k141_402023_4616_5203_Fi_035.fas",
		virus_db="/home/yzitzmann/paper/viral_protein_database/final/viral_protein_ivspers_fila_nophages_nopolydna_LbFV_lef5.faa"
	output:
		blast_hits="output/blast/orf108.tbl",
		hits_accessions="output/blast/orf108.txt",
		hits_fasta="output/blast/orf108.faa"
	threads:
		10
	conda:
		"envs/blast_seqkit.yml"
	shell:
		"""
		blastp -query {input.cluster} -subject {input.virus_db} -evalue 0.001 -out {output.blast_hits} -outfmt 6
		cut -f 2 {output.blast_hits} > {output.hits_accessions}
		seqkit grep -f {output.hits_accessions} {input.virus_db} -o {output.hits_fasta}
		cat {output.hits_fasta} >> {input.cluster}
		"""

# align cluster sequences
rule Alignment:
	input:
			cluster="data/FASTA/{cluster_IDs}.fas"
	output:
			alignment="output/alignment/{cluster_IDs}.fas"
	threads:
			10
	conda:
			"envs/clustalO.yml"
	shell:
			"""
			clustalo --threads {threads} -i {input.cluster} -o {output.alignment}
			"""

# reconstruct phylogeny of clusters
rule phylogeny:
	input:
			alignment="output/alignment/{cluster_IDs}.fas"
	output:
			phylogeny="output/phylogeny/{cluster_IDs}.logs"
	threads:
			20
	conda:
			"envs/iqtree.yml"
	shell:
			"""
			mkdir -p output/phylogeny/{wildcards.cluster_IDs}
			iqtree -s {input.alignment} -m MFP -alrt 1000 -B 1000 --prefix /home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny_lost_EVEs/output/phylogeny/{wildcards.cluster_IDs}/{wildcards.cluster_IDs} > {output.phylogeny}
			"""

# --> -m MFP: perform ModelFinder and the remaining analysis using the selected model
# --> - alrt 1000: number of bootstrap replicates
# --> skip trimming step as this can lead to loss of topology information at amino acid level
