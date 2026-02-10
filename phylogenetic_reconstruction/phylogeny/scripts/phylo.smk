# Snakemake script to infer the phylogeny of Filamentoviridae EVEs

import pandas as pd

# wildcards
cluster_IDs_table=pd.read_csv("/home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny/data/cluster_IDs.txt",header=None)
list_cluster_IDs=list(cluster_IDs_table[0])

rule all:
	input:
		"data/Fila_EVEs.txt",
		"data/Fila_clusters.tsv",
		expand("data/tmp/{cluster_IDs}.tsv", cluster_IDs = list_cluster_IDs),
		expand("data/single_clusters/{cluster_IDs}.tsv", cluster_IDs = list_cluster_IDs),
		expand("data/FASTA/{cluster_IDs}.fas", cluster_IDs = list_cluster_IDs),
		expand("output/alignment/{cluster_IDs}.fas", cluster_IDs = list_cluster_IDs),
		expand("output/phylogeny/{cluster_IDs}.logs", cluster_IDs = list_cluster_IDs)

# filter all clusters with Fila_EVEs
rule Fila_clusters:
	input:
		EVEs="/home/yzitzmann/paper/endogenization_test/EVEs/output/all_EVEs.txt",
		clusters="/home/yzitzmann/paper/phylogenetic_reconstruction/clustering/output/EVE_clusters/EVE_clusters.tsv"
	output:
		Fila_EVEs="data/Fila_EVEs.txt",
		Fila_clusters="data/Fila_clusters.tsv"
	threads:
		2
	shell:
		"""
		grep "Filamentoviridae" {input.EVEs} | cut -f 2 | sed 's/(-)//g' | sed 's/(+)//g' | sed 's/-/_/g' | sed 's/:/_/g' > {output.Fila_EVEs}
		grep -f {output.Fila_EVEs} {input.clusters} > {output.Fila_clusters}
		"""

# create a FASTA-file for every cluster
rule cluster_FASTA:
	input:
			clusters="data/Fila_clusters.tsv",
			FASTA="data/EVE_virus.faa"
	output:
			tmp="data/tmp/{cluster_IDs}.tsv",
			single_clusters="data/single_clusters/{cluster_IDs}.tsv",
			FASTA="data/FASTA/{cluster_IDs}.fas"
	threads:
			2
	conda:
			"envs/seqkit.yml"
	shell:
			"""
			# create list of IDs present in all clusters
			grep {wildcards.cluster_IDs} {input.clusters} > {output.tmp}
			tr '\t' '\n' < {output.tmp} > {output.single_clusters}

			# create fasta-files for all clusters
			seqkit grep -f {output.single_clusters} {input.FASTA} -o {output.FASTA}
			"""

# align cluster sequences
rule Alignment:
	input:
			cluster="data/FASTA/{cluster_IDs}.fas"
	output:
			alignment="output/alignment/{cluster_IDs}.fas"
	threads:
			2
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
			r"""
			number=$(grep -c "^>" {input.alignment})
 
			if [ "$number" -lt 4 ]; then
			mkdir -p output/phylogeny/{wildcards.cluster_IDs}
                        iqtree -s {input.alignment} -m MFP -alrt 1000 --prefix /home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny/output/phylogeny/{wildcards.cluster_IDs}/{wildcards.cluster_IDs} > {output.phylogeny}
			
			else
			mkdir -p output/phylogeny/{wildcards.cluster_IDs}
			iqtree -s {input.alignment} -m MFP -alrt 1000 -B 1000 --prefix /home/yzitzmann/paper/phylogenetic_reconstruction/phylogeny/output/phylogeny/{wildcards.cluster_IDs}/{wildcards.cluster_IDs} > {output.phylogeny}

			fi
			"""
# --> -m MFP: perform ModelFinder and the remaining analysis using the selected model
# --> -alrt 1000: number of bootstrap replicates (SH-like approximate likelihood test)
# --> -B 1000: number of boostrap replicates (ultrafast bootstrap support)
# --> bootstrap is just run when more than 4 sequences in alignment, as otherwise failure
# --> skip trimming step as this can lead to loss of topology information at amino acid level
