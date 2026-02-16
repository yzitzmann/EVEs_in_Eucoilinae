*** ReadME endogenization_test ***
Contents of this directory represent the sixth step of the workflow.
This directory is split into the subdirectories "BUSCO_confirmation", "seq_depth_confirmation", "depth_and_EVEs"
and "EVEs" the first three of which represent one of the three endogenization criteria explained below.

The script "BUSCO_confirmation/scripts/BUSCO.smk" confirms EVEs by identifying BUSCOs in the Figitidae genomes and
identifying EVE candidates occuring on the same contigs as BUSCOs.
The script "seq_depth_confirmation/scripts/seq_depth.smk" confirms EVEs by calculating the sequencing depth of all
contigs and identifying candidates with a sequencing Depth ranging between th 15th and 85th percentile of the BUSCO
distribution (seq_depth_confirmation/scripts/sequencing_depth.R).
The script "TE_and_depth/scripts/TE_and_depth.smk" confirms EVEs by identifying candidates with a sequencing depth
ranging within the 5th to 95th percentile of the BUSCO distribution as well as a transposable element (TE) on the
same contig.
The script "EVEs/scripts/merge_EVEs.sh" merges all identified EVEs to a single file.

Used software and versions are mentioned in the scripts listed above as well as in the yml-files under the
directories envs.

Detailed Description:
"Finally, we used three endogenization criteria to discriminate between EVEs and free-living virus sequences
accepting candidates which meet at least one criteria:

1.	A contig containing a candidate locus also contains a hymenopteran benchmarking universal single-copy ortholog
	(BUSCO).
2.	A contig containing a candidate locus exhibits a sequencing depth within the 15th to 85th percentile of the
	BUSCO-containing contigs (Benjamini-Hochberg adjusted).
3.	A contig containing a candidate locus exhibits a sequencing depth within the 5th to 95th percentile of the
	BUSCO-containing contigs (Benjamini-Hochberg adjusted) as well as a non-overlapping transposon.

To identify EVEs with the first criterion, we ran a BUSCO search (Tegenfeldt et al., 2025) against the Hymenoptera
odb12 database and matched contigs with at least one fragmented or complete BUSCO to the candidate-containing
contigs. For the second and third criterion, we inferred the average sequencing depth of contigs containing BUSCOs
(null distribution) as well as candidate loci either using bwa-mem2 (Vasimuddin et al., 2019) and samtools
(Danecek et al., 2021), or from the genome assembly. We compared the null distribution to candidate contigs,
controlled the false discovery rate (Benjamini & Hochberg, 1995) and accepted candidates with a minimum p-value of
0.15 as well as 0.05 and a transposon respectively."

Software:
Danecek P., Bonfield J.K., Liddle J., Marshall J., Ohan V., Pollard M.O., Whitwham A., Keane T., McCarthy S.A.,
	Davies R.M., Li H. (2021). Twelve years of SAMtools and BCFtools. GigaScience, 10(2), giab008.
	https://doi.org/10.1093/gigascience/giab008
Müller K., Wickham H. (2023). tibble: Simple Data Frames (Version 3.3.0) [Computer software].
	https://CRAN.R-project.org/package=tibble
Shen W., Le S., Li Y., Hu F. (2016). SeqKit: A Cross-Platform and Ultrafast Toolkit for FASTA/Q File Manipulation.
	PLOS ONE, 11(10), e0163962. https://doi.org/10.1371/journal.pone.0163962 
Tegenfeldt F., Kuznetsov D., Manni M., Berkeley M., Zdobnov E.M., Kriventseva E.V. (2025). OrthoDB and BUSCO update:
	annotation of orthologs with wider sampling of genomes. Nucleic Acids Research, 53(D1).
	https://doi.org/10.1093/nar/gkae987
Vasimuddin M., Misra S., Li H., Aluru S. (2019). Efficient Architecture-Aware Acceleration of BWA-MEM for Multicore
	Systems. IEEE International Parallel and Distributed Processing Symposium (IPDPS), 314–324.
	https://doi.org/10.1109/IPDPS.2019.00041
Wickham H. (2023). stringr: Simple, Consistent Wrappers for Common String Operations [Computer software].
	https://CRAN.R-project.org/package=stringr
Wickham H., François R., Henry L., Müller K., Vaughan D. (2023). dplyr: A Grammar of Data Manipulation
	(Version 1.1.4) [Computer software]. https://CRAN.Rproject.org/package=dplyr

Literature:
Benjamini Y., Hochberg Y. (1995). Controlling the False Discovery Rate: A Practical and Powerful Approach to
	Multiple Testing. Journal of the Royal Statistical Society, 57(1), 289–300.
	https://doi.org/10.1111/j.2517-6161.1995.tb02031.x