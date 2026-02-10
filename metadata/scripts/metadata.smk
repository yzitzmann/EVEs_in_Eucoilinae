# Snakemake script to acquire metadata on EVE candidates

#software
mmseqs2="/home/yzitzmann/paper/homology_search/mmseqs/bin/mmseqs"

rule all:
        input:
                "output/metadata_aa.m8",
                "output/metadata.txt"

# new mmseqs-search to obtain m8 files
rule homology_search:
        input:
                Viraldb="/home/yzitzmann/paper/homology_search/data/viral_protein_ivspers_fila_nophages_nopolydna_LbFVlef5",
                Loci="/home/yzitzmann/paper/taxonomy_filter/output/filtered_loci/candidate_loci.faa"
        output:
                metadata="output/metadata_aa.m8"
        threads:
                20
        shell:
                """
                #Create the query database
                {mmseqs2} createdb {input.Loci} output/query/mmseqs2_db

                #Run Mmseqs2 search (BlastX equivalent, homology search between query and db)
                {mmseqs2} search output/query/mmseqs2_db {input.Viraldb} output/results/result_mmseqs2 output/tmp -a -s 7.5 -c 0.3 --min-seq-id 0.2 -e 0.002  --threads {threads} --remove-tmp-files

                #From the previous step you get one result file per thread, the next step will format the result column and also put together all the results in one file:
                {mmseqs2} convertalis --format-output 'query,qlen,tlen,target,qstart,qend,qframe,tstart,tend,evalue,tcov,pident,alnlen,mismatch,gapopen,bits,qaln' output/query/mmseqs2_db {input.Viraldb} output/results/result_mmseqs2 {output.metadata}
                """
# --> now protein-protein search!

# add taxonomic and genomic structure data
rule create_table:
        input:
                metadata="output/metadata_aa.m8",
                families="data/accessions_vFam.txt",
                phages="data/phages_ICTV.txt",
                fila="data/filamentoviridae.acc",
                structure="data/virus_genome_structure.txt",
                classes="data/accessions_vCla.txt"
        output:
                detected_phages="output/detected_phages.txt",
                metadata="output/metadata.txt"
        threads:
                20
        conda:
                "envs/R2.yml"
        script:
                "scripts/metadata.R"
