# Snakemake script to form clusters of viral proteins with species phylogeny 

mmseqs2="/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs"

rule all:
	input:
		"data/EVE_contigs.txt",
		"data/EVEs.faa",
		"data/EVE_virus.faa",
		"output/clusters.tsv",
		"output/labels_clusters.tsv"

# identify all EVE loci
rule EVE_loci:
	input:
		EVEs="data/all_EVEs_and_candidates.txt"
	output:
		EVE_contigs="data/EVE_contigs.txt"
	threads:
		1
	shell:
		"""
		cut -f 2 {input.EVEs} > {output.EVE_contigs}
		"""

# create fasta sequences of all EVE loci
rule filter_EVEs:
	input:
		Loci_aa="/home/yzitzmann/paper/taxonomy_filter/output/filtered_loci/candidate_loci.faa",
		EVE_contigs="data/EVE_contigs.txt"
	output:
		EVE_aa="data/EVEs.faa"
	threads:
		1
	conda:
		"envs/seqkit.yml"
	shell:
		"""
		seqkit grep -f {input.EVE_contigs} {input.Loci_aa} -o {output.EVE_aa}
		"""

# merge Fasta-files of virus proteins and EVEs
rule concatenate:
	input:
		EVE_aa="data/EVEs.faa",
		virus_aa="data/viral_protein_ivspers_fila_nophages_nopolydna_LbFV_lef5.faa",
	output:
		EVE_virus="data/EVE_virus.faa"
	threads:
		1
	shell:
		"""
		cat {input.EVE_aa} {input.virus_aa} > {output.EVE_virus}
		"""

# form clusters between virus sequences and EVEs
rule cluster:
	input:
		EVE_virus="data/EVE_virus.faa"
	output:
		clusters="output/clusters.tsv"
	threads:
		30
	shell:
		"""
		# create output directories
		mkdir -p output/clustering/EVE_clusters

		# create mmseqs2-database
		{mmseqs2} createdb {input.EVE_virus} output/mmseqs_DB

		# run clustering algorithm
		{mmseqs2} cluster output/mmseqs_DB output/clustering/EVE_clusters output/tmp -s 7.5 --cluster-mode 1 --cov-mode 0 -c 0.25 -e 0.001 --threads {threads}
		
		# format output
		{mmseqs2} createtsv output/mmseqs_DB output/mmseqs_DB output/clustering/EVE_clusters {output.clusters}
		"""

# modify cluster labels
rule labels:
	input:
		clusters="output/clusters.tsv"
	output:
		clusters="output/labels_clusters.tsv",
	threads:
		5
	shell:
		"""
		# remove all (-), (+), -  and : characters in clusters as well as change cluster file layout
		sed 's/(-)//g' {input.clusters} | sed 's/(+)//g' | sed 's/-/_/g' | sed 's/:/_/g' > {output.clusters}
		"""

