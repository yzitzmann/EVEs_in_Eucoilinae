*** ReadME homology_search ***
Contents of this directory represent the second step of the workflow.
The script "scripts/Viral_homology.smk" compares the viral protein database to the Figitidae genomes, merges overlapping hits ("scripts/merge_loci.R")
and extracts the identified EVE candidate sequences (scripts/Extract_and_translate_loci.py).

Used software and versions are mentioned in the script "scripts/Viral_homology.smk" as well as in the yml-files under the directory envs.

Detailed Description:
"We conducted a MMseqs2 search (Steinegger & Söding, 2017) against the virus protein dataset (s 7.5, c 0.3, min_seq_ID 0.2, E-value 0.002).
Parameters were optimized for allowing the detection of as many known endogenized Filamentoviridae sequences as possible in Leptopilina heterotoma.
Then, we merged overlapping hits on the Figitidae genomes using GenomicRanges (Lawrence et al. 2013) and extracted the candidate sequences."

Software:
Lawrence M, Huber W, Pagès H, Aboyoun P, Carlson M, Gentleman R, Morgan MT, Carey VJ (2013) Software for Computing and Annotating Genomic Ranges. 
	PLoS Computational Biology, 9(8), e1003118. https://doi.org/10.1371/journal.pcbi.1003118
Pagès H, Lawrence M, Aboyoun P (2024) S4Vectors: Foundation of vector-like and list-like containers in Bioconductor (Version 0.44.0) [Computer software]. 	https://bioconductor.org/packages/S4Vectors
Steinegger M, Söding J (2017) MMseqs2 enables sensitive protein sequence searching for the analysis of massive data sets. Nature Biotechnology, 35, 
	1026–1028. https://doi.org/10.1038/nbt.3988
Wickham H, François R, Henry L, Müller K, Vaughan D (2023) dplyr: A Grammar of Data Manipulation (Version 1.1.4) [Computer software]. 	https://CRAN.Rproject.org/package=dplyr
