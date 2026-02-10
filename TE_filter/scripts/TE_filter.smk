# Snakemake-script to identify overlaps between EVE candidates and transposable elements

import pandas as pd

# lists
Genome_IDs_table=pd.read_csv("/home/yzitzmann/paper/homology_search/genome_IDs_table.txt",header=None)
list_Genome_IDs=list(Genome_IDs_table[0])

#Your softs
mmseqs2="/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs"

rule all:
	input:
		"data/RepeatPeps",
		expand("output/mmseqs2/{Genome_ID}/result_mmseqs2.m8", Genome_ID=list_Genome_IDs),
		expand("output/genome_metadata/{Genome_ID}.txt", Genome_ID=list_Genome_IDs),
		expand("output/overlap/{Genome_ID}_overlaps.txt", Genome_ID=list_Genome_IDs),
		expand("output/EVE_candidates/{Genome_ID}_candidates.txt", Genome_ID=list_Genome_IDs)

# create TE database
rule create_TE_db:
	input:
		TEdb="data/RepeatPeps.lib"
	output:
		TE_mmseqs2_db="data/RepeatPeps"
	threads:
		5
	shell:
		"""
		{mmseqs2} createdb {input.TEdb} {output.TE_mmseqs2_db}
		"""

# search for transposable elements in genome assemblies using RepeatPeps
rule TE_search:
	input:
		Genomedb="/home/yzitzmann/paper/homology_search/output/mmseqs2/{Genome_ID}/{Genome_ID}_mmseqs2_db",
		TEdb="data/RepeatPeps"
	output:
		out="output/mmseqs2/{Genome_ID}/result_mmseqs2.m8"
	threads:
		15
	shell:
		"""
		#Create a directory where the BlastX results will be written
                mkdir -p output/mmseqs2/{wildcards.Genome_ID}/
		
		#Run Mmseqs2 search (BlastX equivalent, homology search between query and db)
		{mmseqs2} search {input.Genomedb} {input.TEdb} output/mmseqs2/{wildcards.Genome_ID}/result_mmseqs2 output/mmseqs2/{wildcards.Genome_ID}/tpm -a -s 7.5 -c 0.3 --min-seq-id 0.2 -e 0.001 --threads {threads} --remove-tmp-files
		
		#From the previous step you get one result file per thread, the next step will format the result column and also put together all the results in one file:
                {mmseqs2} convertalis --format-output 'query,qlen,tlen,target,qstart,qend,qframe,tstart,tend,evalue,tcov,pident,alnlen,mismatch,gapopen,bits,qaln' {input.Genomedb} {input.TEdb} output/mmseqs2/{wildcards.Genome_ID}/result_mmseqs2 {output.out}
		"""

# divide EVE candidate data by genomes
rule prepare_EVE_candidates:
	input:
		metadata="/home/yzitzmann/paper/metadata/output/metadata.txt"
	output:
		genome_metadata="output/genome_metadata/{Genome_ID}.txt"
	threads:
		1
	shell:
		"""
		grep {wildcards.Genome_ID} {input.metadata} > {output.genome_metadata}
		"""

# identify overlaps between transposable elements and endogenized EVE candidates
rule identify_overlaps:
	input:
		TEs="output/mmseqs2/{Genome_ID}/result_mmseqs2.m8",
		EVE_candidates="output/genome_metadata/{Genome_ID}.txt"
	output:
		overlap="output/overlap/{Genome_ID}_overlaps.txt"
	threads:
		5
	conda:
		"findoverlaps-env"
	script:
		"scripts/findoverlaps.R"

rule remove_TEs:
	input:
		overlap="output/overlap/{Genome_ID}_overlaps.txt",
		EVE_candidates="output/genome_metadata/{Genome_ID}.txt"
	output:
		EVE_candidates="output/EVE_candidates/{Genome_ID}_candidates.txt"
	threads:
		1
	shell:
		"""
		cut -f 7 -d " " {input.overlap} | sed '1d' > output/{wildcards.Genome_ID}_tmp.txt
		grep -vFf output/{wildcards.Genome_ID}_tmp.txt {input.EVE_candidates} > {output.EVE_candidates}
		rm output/{wildcards.Genome_ID}_tmp.txt
		"""
