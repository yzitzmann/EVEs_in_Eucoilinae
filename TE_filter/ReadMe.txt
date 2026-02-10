*** ReadME TE_filter ***
Contents of this directory represent the fifth step of the workflow.

The script "scripts/final_TE_filter.sh" downloads the RepeatPeps library from "https://www.dfam.org/releases/current/families/RepeatPeps.lib.gz".
The script "scripts/TE_filter.sh" identifies overlaps between EVE candidates and transposable elements by conducting an MMseqs2 search (s 7.5, c 0.3, min_seq_ID 0.2, E-value 0.001),
finding overlaps between TEs and EVE candidates (scripts/findoverlaps.R) and finally maintaining only candidates without overlaps.

Used software and versions are mentioned in the script "scripts/TE_filter.sh" as well as in the yml-files under the directories envs.

Detailed Description:
"As we identified a large quantity of virus-like transposons in our EVE candidate dataset, we searched for transposons in the genomes by conducting an Mmseqs2 search
against the RepeatPeps library (Flynn et al. 2020) and removed all EVEs overlapping with transposons using GenomicRanges (Lawrence et al. 2013)."
