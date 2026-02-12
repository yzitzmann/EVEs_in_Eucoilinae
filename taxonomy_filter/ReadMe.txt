*** ReadME taxonomy_filter ***
Contents of this directory represent the third step of the workflow.
The script "scripts/create_tax_db.sh" downloads the NR database from NCBI and removes all Figitidae and PolyDNAviriformidae sequences from that database.
The script "scripts/taxonomy_assignment.smk" compares the EVE candidate sequences to the NR database to compute the most recent common ancestors and keeps only those for which a viral most recent ancestor is recovered.

Used software and versions are mentioned in the script "scripts/taxonomy_assignment.smk" as well as in the yml-files under the directory envs.

Detailed Description:
"We compared all resulting matches of the MMseqs2 search (candidate loci) to the NCBI NR database (Sayers et al., 2023) using MMSeqs2 easy-taxonomy (lca-mode 4, tax-lineage 1, E-value 0.00001). We removed all Figitidae and Polydnaviriformidae sequences from the NR database and maintained only candidate loci for which MMseqs2 computed a viral most recent common ancestor."

Software:
Shen W, Le S, Li Y, Hu F (2016) SeqKit: A Cross-Platform and Ultrafast Toolkit for FASTA/Q File Manipulation. PLOS ONE, 11(10), e0163962. 
	https://doi.org/10.1371/journal.pone.0163962
Steinegger M, Söding J (2017) MMseqs2 enables sensitive protein sequence searching for the analysis of massive data sets. Nature Biotechnology, 35, 
	1026–1028. https://doi.org/10.1038/nbt.3988

Literature:
Sayers EW, Bolton EE, Brister JR, Canese K, Chan J, Comeau DC, Farrell CM, Feldgarden M, Fine AM, Funk K, Hatcher E, Kannan S, Kelly C, Kim S, Klimke 
	W, Landrum MJ, Lathrop S, Lu Z, Madden TL, Malheiro A, Marchler-Bauer A, Murphy TD, Phan L, Pujar S, Rangwala SH, Schneider VA, Tse T, Wang J. Ye 
	J, Trawick BW, Pruitt KD, Sherry ST (2023) Database resources of the National Center for Biotechnology Information in 2023. Nucleic Acids Research, 	51(D1), D29–D38. https://doi.org/10.1093/nar/gkac1032
