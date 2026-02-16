*** ReadME homology_search ***
Contents of this directory represent the second step of the workflow.
The script "scripts/Viral_homology.smk" compares the viral protein database to the Figitidae genomes, merges
overlapping hits ("scripts/merge_loci.R") and extracts the identified EVE candidate sequences
(scripts/Extract_and_translate_loci.py).

Used software and versions are mentioned in the script "scripts/Viral_homology.smk" as well as in the yml-files
under the directory envs.

Detailed Description:
"We conducted a MMseqs2 search (Steinegger & Söding, 2017) against the virus protein dataset (s 7.5, c 0.3,
min_seq_ID 0.2, E-value 0.002). Parameters were optimized for allowing the detection of as many known endogenized
Filamentoviridae sequences as possible in Leptopilina heterotoma. Then, we merged overlapping hits on the Figitidae
genomes using GenomicRanges (Lawrence et al. 2013) and extracted the candidate sequences."

Software:
Cock P.J.A., Antao T., Chang J.T., Chapman B.A., Cox C.J., Dalke A., Friedberg I., Hamelryck T., Kauff F.,
	Wilczynski B., de Hoon M.J.L. (2009). Biopython: Freely  available Python tools for computational molecular
	biology and bioinformatics. Bioinformatics, 25(11), 1422–1423. https://doi.org/10.1093/bioinformatics/btp163
Harris C.R., Millman K.J., Van Der Walt S.J., Gommers R., Virtanen P., Cournapeau D., Wieser E., Taylor J., Berg S.,
	Smith N.J., Kern R., Picus M., Hoyer S., Van Kerkwijk M.H., Brett M., Haldane A., Del Río J.F., Wiebe M.,
	Peterson P., Gérard-Marchant P., Sheppard K., Reddy T., Weckesser W., Abbasi H., Gohlke C., Oliphant T.E. (2020).
	Array programming with NumPy. Nature, 585, 357–362. https://doi.org/10.1038/s41586-020-2649-2
Lawrence M., Huber W., Pagès H., Aboyoun P., Carlson M., Gentleman R., Morgan M.T., Carey V.J. (2013). Software for
	Computing and Annotating Genomic Ranges. PLoS Computational Biology, 9(8), e1003118.
	https://doi.org/10.1371/journal.pcbi.1003118
McKinney W. (2010). Data Structures for Statistical Computing in Python. Python in Science Conference, 56–61.
	https://doi.org/10.25080/Majora-92bf1922-00a
Pagès H., Lawrence M., Aboyoun P. (2024). S4Vectors: Foundation of vector-like and list-like containers in
	Bioconductor (Version 0.44.0) [Computer software]. 	https://bioconductor.org/packages/S4Vectors
Steinegger M., Söding J. (2017). MMseqs2 enables sensitive protein sequence searching for the analysis of massive
	data sets. Nature Biotechnology, 35, 1026–1028. https://doi.org/10.1038/nbt.3988
Wickham H., François R., Henry L., Müller K., Vaughan D. (2023). dplyr: A Grammar of Data Manipulation
	(Version 1.1.4) [Computer software]. https://CRAN.Rproject.org/package=dplyr
