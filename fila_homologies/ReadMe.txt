*** ReadME fila_homologies ***
The script "scripts/fila_homologies.sh" compares Filamentoviridae proteins to the Eucoilini and Trichoplastini genomes
and merges overlapping hits ("scripts/merge_loci.R").

Used software and versions are mentioned in the script "scripts/fila_homologies.sh" as well as in the yml-files under the directory envs.

Detailed Description:
"Due to the large quantity of sequencing depth-confirmed Filamentoviridae EVEs in Cothonaspis longula, we looked for signes of viral infection
in C. longula. Thus, we conducted a MMseqs2 search (Steinegger & Söding, 2017) of Eucoilini and Trichoplastini genomes against the Filamentoviridae
subset (s 7.5, c 0.7, min_seq_ID 0.25, E-value 0.001). Parameters were chosen to detect non-fragmented Filamentoviridae homologues."

Software:
Lawrence M, Huber W, Pagès H, Aboyoun P, Carlson M, Gentleman R, Morgan MT, Carey VJ (2013) Software for Computing and Annotating Genomic Ranges. 
	PLoS Computational Biology, 9(8), e1003118. https://doi.org/10.1371/journal.pcbi.1003118 
Pagès H, Lawrence M, Aboyoun P (2024) S4Vectors: Foundation of vector-like and list-like containers in Bioconductor (Version 0.44.0) [Computer software]. 
	https://bioconductor.org/packages/S4Vectors
Sayers EW, Beck J, Bolton EE, Brister JR, Chan J, Connor R, Feldgarden M, Fine AM, Funk K, Hoffman J, Kannan S, Kelly C, Klimke W, Kim S, Lathrop S, Marchler-	Bauer A, Murphy TD, O'Sullivan C, Schmieder E, Skripchenko Y, Stine A, Thibaud-Nissen F, Wang J, Ye J, Zellers E, Schneider VA, Pruitt KD (2025) 	Database resources of the National Center for Biotechnology Information in 2025. Nucleic Acids Res., 53(D1), D20-D29. doi: 10.1093/nar/gkae979
Steinegger M, Söding J (2017) MMseqs2 enables sensitive protein sequence searching for the analysis of massive data sets. Nature Biotechnology, 35, 
	1026–1028. https://doi.org/10.1038/nbt.3988
Wickham H, François R, Henry L, Müller K, Vaughan D (2023) dplyr: A Grammar of Data Manipulation (Version 1.1.4) [Computer software]. 	https://CRAN.Rproject.org/package=dplyr 