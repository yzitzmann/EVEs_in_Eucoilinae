*** ReadME TE_filter ***
Contents of this directory represent the fifth step of the workflow.

The script "scripts/final_TE_filter.sh" downloads the RepeatPeps library from "https://www.dfam.org/releases/current/families/RepeatPeps.lib.gz".
The script "scripts/TE_filter.smk" identifies overlaps between EVE candidates and transposable elements by conducting an MMseqs2 search (s 7.5, c 0.3, min_seq_ID 0.2, E-value 0.001), finding overlaps between TEs and EVE candidates (scripts/findoverlaps.R) and finally maintaining only candidates without overlaps.

Used software and versions are mentioned in the script "scripts/TE_filter.sh" as well as in the yml-files under the directories envs.

Detailed Description:
"As we identified a large quantity of virus-like transposons in our EVE candidate dataset, we searched for transposons in the genomes by conducting an Mmseqs2 search against the RepeatPeps library (Storer et al. 2021) and removed all EVEs overlapping with transposons using GenomicRanges (Lawrence et al. 2013)."

Software:
Lawrence M, Huber W, Pagès H, Aboyoun P, Carlson M, Gentleman R, Morgan MT, Carey VJ (2013) Software for Computing and Annotating Genomic Ranges. 
	PLoS Computational Biology, 9(8), e1003118. https://doi.org/10.1371/journal.pcbi.1003118 
Pagès H, Lawrence M, Aboyoun P (2024) S4Vectors: Foundation of vector-like and list-like containers in Bioconductor (Version 0.24.0) [Computer software]. 
	https://bioconductor.org/packages/S4Vectors
Steinegger M, Söding J (2017) MMseqs2 enables sensitive protein sequence searching for the analysis of massive data sets. Nature Biotechnology, 35, 
	1026–1028. https://doi.org/10.1038/nbt.3988
Wickham H (2023) stringr: Simple, Consistent Wrappers for Common String Operations [Computer software].
	https://CRAN.R-project.org/package=stringr
Wickham H, François R, Henry L, Müller K, Vaughan D (2023) dplyr: A Grammar of Data Manipulation (Version 1.1.4) [Computer software]. 	https://CRAN.Rproject.org/package=dplyr

Literature:
Storer J, Hubley R, Rosen J, Wheeler TJ, Smit AF (2021) The Dfam community resource of transposable element families, sequence models, and Genome annotations.
	Mobile DNA, 12(2), https://doi.org/10.1186/s13100-020-00230-y