# Snakemake script to calculate sequencing depth of all candidate-containing and BUSCO-containing contigs as well as confirm EVEs by sequencing depth criterion

import pandas as pd

# lists
Genome_IDS_table=pd.read_csv("/home/yzitzmann/paper/endogenization_test/seq_depth_confirmation/genome_IDs_table.txt",header=None)
list_Genome_IDs=list(Genome_IDS_table[0])

# directory abbreviations
Sequence_dir="/share/pool/gbol3_figitidae_wgs/figi_wgs_workflow/resources/copied_data/"

rule all:
	input:
		#expand(Sequence_dir+"SAM/{Genome_ID}.sam", Genome_ID = list_Genome_IDs),
		#expand(Sequence_dir+"BAM/{Genome_ID}.bam", Genome_ID = list_Genome_IDs),
		#expand("output/depth_all_contigs/{Genome_ID}.txt", Genome_ID = list_Genome_IDs),
		expand("output/candidate_contigs/{Genome_ID}_candidate_contigs.txt", Genome_ID = list_Genome_IDs),
		expand("output/BUSCO_depth/{Genome_ID}_BUSCO_depth.txt", Genome_ID = list_Genome_IDs),
		expand("output/candidate_depth/{Genome_ID}_candidate_depth.txt", Genome_ID = list_Genome_IDs),
		expand("output/EVE_contigs/{Genome_ID}_15_85.txt", Genome_ID = list_Genome_IDs),
		expand("output/EVE_contigs/{Genome_ID}_5_95.txt", Genome_ID = list_Genome_IDs),
		expand("output/all_contigs_Ps/{Genome_ID}.txt", Genome_ID = list_Genome_IDs),
		expand("output/EVE_contigs/contigs_only/{Genome_ID}.txt", Genome_ID = list_Genome_IDs),
		expand("output/EVEs/{Genome_ID}_depth_EVEs.txt", Genome_ID = list_Genome_IDs)

# map sequence reads to reference genomes
rule Mapping:
	input:
		genomedb="/home/yzitzmann/paper/homology_search/genomes/{Genome_ID}.fa",
		reads=Sequence_dir+"combined/{Genome_ID}.fastq"
	output:
		map_reads=Sequence_dir+"SAM/{Genome_ID}.sam"
	threads:
		15
	conda:
		"envs/bwa-mem2.yml"
	shell:
		"""
		# index genome
		bwa-mem2 index {input.genomedb}

		# map reads to genome
		bwa-mem2 mem -t {threads} {input.genomedb} {input.reads} > {output.map_reads}
		"""
# --> mapped sequence reads are used to calculate sequencing depth for all nodes in rule "coverage_depth"

# calculate sequencing depth for all genome contigs
rule sequencing_depth:
	input:
		map=Sequence_dir+"SAM/{Genome_ID}.sam"
	output:
		BAM=Sequence_dir+"BAM/{Genome_ID}.bam",
		depth="output/depth_all_contigs/{Genome_ID}.txt"
	threads:
		15
	conda:
		"envs/samtools.yml"
	shell:
		"""
		# sort sam files and convert to bam files
		samtools sort {input.map} -O bam -o {output.BAM}

		# calculate sequencing depth from bam files
		samtools coverage {output.BAM} > {output.depth}
		"""
# --> sequencing depth is displayed by "meandepth" metric in text-files

# identify sequencing depth of candidate- and BUSCO-containing nodes
rule Identify_depth:
	input:
		BUSCO_contigs="/home/yzitzmann/paper/endogenization_test/BUSCO_confirmation/output/BUSCO_contigs/{Genome_ID}_BUSCO_contigs.txt",
		EVE_candidates="/home/yzitzmann/paper/TE_filter/output/EVE_candidates/all_candidates.txt",
		depth="output/depth_all_contigs/{Genome_ID}.txt"
	output:
		candidate_contigs="output/candidate_contigs/{Genome_ID}_candidate_contigs.txt",
		BUSCO_depth="output/BUSCO_depth/{Genome_ID}_BUSCO_depth.txt",
		candidate_depth="output/candidate_depth/{Genome_ID}_candidate_depth.txt"
	threads:
		3
	shell:
		"""
		# extract EVE candidate contigs for each genome from metadata-file
		grep {wildcards.Genome_ID} {input.EVE_candidates} | cut -f 3 | sort | uniq > {output.candidate_contigs}

		# identify depth of BUSCO- and candidate-contigs
		awk 'NR==FNR {{ ids[$1]; next }} $1 in ids' {input.BUSCO_contigs} {input.depth} > {output.BUSCO_depth}
		awk 'NR==FNR {{ ids[$1]; next }} $1 in ids' {output.candidate_contigs} {input.depth} > {output.candidate_depth}
		"""
# --> sequencing depth of BUSCO- and candidate-containing contigs stored in output files

rule statistics:
	input:
		BUSCO="output/BUSCO_depth/{Genome_ID}_BUSCO_depth.txt",
		candidate="output/candidate_depth/{Genome_ID}_candidate_depth.txt"
	output:
		percentile_one="output/EVE_contigs/{Genome_ID}_15_85.txt",
		percentile_two="output/EVE_contigs/{Genome_ID}_5_95.txt",
		all_p_values="output/all_contigs_Ps/{Genome_ID}.txt"
	threads:
		5
	conda:
		"envs/R.yml"
	script:
		"scripts/sequencing_depth.R"

# --> {Genome_ID}_15_85.txt contains all nodes fulfilling the 15th to 85th percentile requirement
# --> {Genome_ID}_5_95.txt contains all nodes fulfilling the 5th to 95th percentile requirement, but not the 15th to 85th perecentile requirement

# extract depth-confirmed EVEs
rule EVEs:
	input:
		EVE_depth="output/EVE_contigs/{Genome_ID}_15_85.txt",
		metadata="/home/yzitzmann/paper/TE_filter/output/EVE_candidates/all_candidates.txt"
	output:
		EVE_contigs="output/EVE_contigs/contigs_only/{Genome_ID}.txt",
		EVEs="output/EVEs/{Genome_ID}_depth_EVEs.txt"
	threads:
		1
	shell:
		"""
		cut -f 1 {input.EVE_depth} | sed '1d' > {output.EVE_contigs}
		grep -f {output.EVE_contigs} {input.metadata} | grep {wildcards.Genome_ID} > {output.EVEs}
		"""
