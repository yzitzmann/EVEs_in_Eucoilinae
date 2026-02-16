*** ReadME metadata ***
Contents of this directory represent the fourth step of the workflow.
The script "scripts/final_metadata.sh" extracts taxonomic data on the virus class and family of NCBI accession
numbers from "data/viral_protein_refseq_release_viral_Apr21_2025.gpff". The script "scripts/metadata.smk" compares
the EVE candidate sequences to the viral protein database and adds metadata on taxonomic classification and genomic
structure of the viral protein matches (scripts/metdata.R).

Used software and versions are mentioned in the script "scripts/metadata.sh" as well as in the yml-files under the
directory envs.

Files in the directory "data" not created by a script originate from:
-->     phages_ICTV.txt created on June 29, 2025 by manually retrieving all virus families with bacterial and
		archeael host from "https://ictv.global/virus-	properties"

-->     phage classes in "scripts/metadata.R" identified by retrieving all virus classes from ICTV
		(https://ictv.global/taxonomy) and manually checking for bacterial and archeael hosts on NCBI virus
		(https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/) on November 18, 2024

-->     virus_genome_structure.txt created on June 29, 2025 by manually retrieving genome data from
		"https://ictv.global/virus-properties"

Detailed Description:
"We ran an identical second MMseqs2 search using the remaining candidate loci as queries to acquire metadata (s 7.5,
c 0.3, min_seq_ID 0.2, E-value 0.002). Additionally, taxonomic data on free-living viruses as well as their genomic
structures was gathered from NCBI (Goldfarb et al., 2025) as well as the International Council on Virus Taxonomy
(Black et al., 2026)."

Software:
Müller K., Wickham H. (2023). tibble: Simple Data Frames (Version 3.3.0) [Computer software].
	https://CRAN.R-project.org/package=tibble
Steinegger M., Söding J. (2017). MMseqs2 enables sensitive protein sequence searching for the analysis of massive
	data sets. Nature Biotechnology, 35, 1026–1028. https://doi.org/10.1038/nbt.3988 
Wickham H. (2023). stringr: Simple, Consistent Wrappers for Common String Operations [Computer software].
	https://CRAN.R-project.org/package=stringr 
Wickham H., François R., Henry L., Müller K., Vaughan D. (2023). dplyr: A Grammar of Data Manipulation
	(Version 1.1.4) [Computer software]. https://CRAN.Rproject.org/package=dplyr

Literature:
Black, Eden J., C. Steve Powell, Donald M. Dempsey, R. Curtis Hendrickson, Logan R. Mims, and Elliot J. Lefkowitz.
	“Virus Taxonomy: The Database of the International Committee on Taxonomy of Viruses.” Nucleic Acids Research
	54, no. D1 (2026): D776–89. https://doi.org/10.1093/nar/gkaf1159.
Goldfarb, T., Kodali, V. K., Pujar, S., Brover, V., Robbertse, B., Farrell, C. M., Oh, D.-H., Astashyn, A.,
	Ermolaeva, O., Haddad, D., Hlavina, W., Hoffman, J., Jackson, J. D., Joardar, V. S., Kristensen, D., Masterson,
	P., McGarvey, K. M., McVeigh, R., Mozes, E., … Murphy, T. D. (2025). NCBI RefSeq: Reference sequence standards
	through 25 years of curation and annotation. Nucleic Acids Research, 53(D1), D243–D257.
	https://doi.org/10.1093/nar/gkae1038