*** ReadME endogenization_test ***
Contents of this directory represent the sixth step of the workflow.
This directory is split into the subdirectories "BUSCO_confirmation", "seq_depth_confirmation", "depth_and_EVEs" and "EVEs" the first three of which represent one of the three endogenization criteria explained below.

The script "BUSCO_confirmation/scripts/BUSCO.sh" confirms EVEs by identifying BUSCOs in the Figitidae genomes and identifying EVE candidates occuring on the same contigs as BUSCOs.
The script "seq_depth_confirmation/scripts/seq_depth.sh" confirms EVEs by calculating the sequencing depth of all contigs and identifying candidates with a sequencing depth
ranging between th 10th and 90th percentile of the BUSCO distribution (seq_depth_confirmation/scripts/sequencing_depth.R).
The script "TE_and_depth/scripts/TE_and_depth.sh" confirms EVEs by identifying candidates with a sequencing depth ranging within BUSCO distribution as well as a transposable element (TE) on the same contig.
The script "EVEs/scripts/merge_EVEs.sh" merges all identified EVEs to a single file.

Used software and versions are mentioned in the scripts listed above as well as in the yml-files under the directories envs.

Detailed Description:
"We used three endogenization criteria to discriminate between EVEs and free-living virus sequences:
	1. A ontig containing a candidate locus also contains a hymenopteran benchmarking universal single-copy ortholog (BUSCO).
	2. A contig containing a candidate locus exhibits a sequencing depth within the 10th to 90th percentile of the BUSCO-containing contigs (Benjamini-Hochberg adjusted).
	3. A contig containing a candidate locus exhibits a sequencing depth within the range of the BUSCO-containing contigs (Benjamini-Hochberg adjusted) as well as a non-overlapping transposon.

To identify EVEs with the first criterion, we ran a BUSCO search against the Hymenoptera odb12 database and matched contigs with at least one fragmented or complete BUSCO to the candidate-containing contigs.
For the second and third criterion, we computed the average sequencing depth of contigs containing BUSCOs (null distribution) as well as candidate loci with bwa-mem2 (Vasimuddin et al., 2019) and samtools (Danecek et al., 2021).
We compared the null distribution to candidate contigs, controlled the false discovery rate (Benjamini & Hochberg, 1995) and accepted candidates with a minimum p-value of 0.1 as well as 0.0 and a transposon respectively."
