*** ReadME homology_search ***
Contents of this directory represent the second step of the workflow.
The script "scripts/Viral_homology.sh" compares the viral protein database to the Figitidae genomes, merges overlapping hits ("scripts/merge_loci.R")
and extracts the identified EVE candidate sequences (scripts/Extract_and_translate_loci.py).

Used software and versions are mentioned in the script "scripts/Viral_homology.sh" as well as in the yml-files under the directory envs.

Detailed Description:
"We conducted a MMseqs2 search (Steinegger & Söding, 2017) against the virus protein dataset (s 7.5, c 0.3, min_seq_ID 0.2, E-value 0.002).
Parameters were optimized for allowing the detection of as many known endogenized Filamentoviridae sequences as possible in Leptopilina heterotoma.
Then, we merged overlapping hits on the Figitidae genomes using GenomicRanges (Lawrence et al. 2013) and extracted the candidate squences."
