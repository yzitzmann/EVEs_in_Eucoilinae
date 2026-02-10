*** ReadME metadata ***
Contents of this directory represent the fourth step of the workflow.
The script "scripts/final_metadata.sh" extracts taxonomic data on the virus class and family of NCBI accession numbers from "data/viral_protein_refseq_release_viral_Apr21_2025.gpff".
The script "scripts/metadata.sh" compares the EVE candidate sequences to the viral protein database and adds metadata on taxonomic classification and genomic structure of the viral protein matches (scripts/metdata.R).

Used software and versions are mentioned in the script "scripts/metadata.sh" as well as in the yml-files under the directory envs.

Files in the directory "data" not created by a script originate from:
-->     phages_ICTV.txt created on June 29, 2025 by manually retrieving all virus families with bacterial and archeael host from "https://ictv.global/virus-properties"

-->     phage classes in "scripts/metadata.R" identified by retrieving all virus classes from ICTV (https://ictv.global/taxonomy) and manually checking for bacterial and
        archeael hosts on NCBI virus (https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/) on November 18, 2024

-->     virus_genome_structure.txt created on June 29, 2025 by manually retrieving genome data from "https://ictv.global/virus-properties"

Detailed Description:
"We ran an identical second MMseqs2 search using the remaining candidate loci as queries to acquire metadata (s 7.5, c 0.3, min_seq_ID 0.2, E-value 0.002).
Additionally, taxonomic data on free-living viruses as well as their genomic structures was gathered from NCBI (O’Leary et al., 2016)
as well as the International Council on Virus Taxonomy (ICTV, Lefkowitz et al., 2018)."
