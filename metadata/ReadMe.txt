*** ReadME metadata ***
Contents of this directory represent the fourth step of the workflow.
The script "scripts/final_metadata.sh" extracts taxonomic data on the virus class and family of NCBI accession numbers from "data/viral_protein_refseq_release_viral_Apr21_2025.gpff".
The script "scripts/metadata.smk" compares the EVE candidate sequences to the viral protein database and adds metadata on taxonomic classification and genomic structure of the viral protein matches (scripts/metdata.R).

Used software and versions are mentioned in the script "scripts/metadata.sh" as well as in the yml-files under the directory envs.

Files in the directory "data" not created by a script originate from:
-->     phages_ICTV.txt created on June 29, 2025 by manually retrieving all virus families with bacterial and archeael host from "https://ictv.global/virus-	properties"

-->     phage classes in "scripts/metadata.R" identified by retrieving all virus classes from ICTV (https://ictv.global/taxonomy) and manually checking for 	bacterial and archeael hosts on NCBI virus (https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/) on November 18, 2024

-->     virus_genome_structure.txt created on June 29, 2025 by manually retrieving genome data from "https://ictv.global/virus-properties"

Detailed Description:
"We ran an identical second MMseqs2 search using the remaining candidate loci as queries to acquire metadata (s 7.5, c 0.3, min_seq_ID 0.2, E-value 0.002).
Additionally, taxonomic data on free-living viruses as well as their genomic structures was gathered from NCBI (O’Leary et al., 2016)
as well as the International Council on Virus Taxonomy (ICTV, Lefkowitz et al., 2018)."

Software:
Müller K, Wickham H (2023) tibble: Simple Data Frames (Version 3.3.0) [Computer software].
	https://CRAN.R-project.org/package=tibble
Steinegger M, Söding J (2017) MMseqs2 enables sensitive protein sequence searching for the analysis of massive data sets. Nature Biotechnology, 35, 
	1026–1028. https://doi.org/10.1038/nbt.3988 
Wickham H (2023) stringr: Simple, Consistent Wrappers for Common String Operations [Computer software].
	https://CRAN.R-project.org/package=stringr 
Wickham H, François R, Henry L, Müller K, Vaughan D (2023) dplyr: A Grammar of Data Manipulation (Version 1.1.4) [Computer software]. 	https://CRAN.Rproject.org/package=dplyr

Literature:
Lefkowitz EJ, Dempsey DM, Hendrickson RC, Orton RJ, Siddell SG, Smith DB (2018) Virus taxonomy: The database of the International Committee on 
	Taxonomy of Viruses (ICTV). Nucleic Acids Research, 46(D1), D708–D717. https://doi.org/10.1093/nar/gkx932 
O’Leary NA, Wright MW, Brister JR, Ciufo S, Haddad D, McVeigh R, Rajput B, Robbertse B, Smith-White B, Ako-Adjei D, Astashyn A, Badretdin A, Bao Y, 
	Blinkova O, Brover V, Chetvernin V, Choi J, Cox E, Ermolaeva O, Farrell CM, Goldfarb T, Gupta T, Haft D, Hatcher E, Hlavina W, Joardar VS, Kodali 	VK, Li W, Maglott D, Masterson P, McGarvey KM, Murphy MR, O’Neill K, Pujar S, Rangwala SH, Rausch D, Riddick LD, Schoch C, Shkeda A, Storz SS, Sun 	H, Thibaud-Nissen F, Tolstoy I, Tully RE, Vatsan AR, Wallin C, Webb D, Wu W, Landrum MJ, Kimchi A, Tatusova T, DiCuccio M, Kitts P, Murphy TD, 	Pruitt KD (2016) Reference sequence (RefSeq) database at NCBI: Current status, taxonomic expansion, and functional annotation. Nucleic Acids 	Research, 44(D1), D733–D745. https://doi.org/10.1093/nar/gkv1189
