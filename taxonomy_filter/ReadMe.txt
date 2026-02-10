*** ReadME taxonomy_filter ***
Contents of this directory represent the third step of the workflow.
The script "scripts/create_tax_db.sh" downloads the NR database from NCBI and removes all Figitidae and PolyDNAviriformidae sequences from that database.
The script "scripts/taxonomy_assignment.sh" compares the EVE candidate sequences to the NR database to compute the most recent common ancestors and keeps only those for which a viral most recent ancestor is recovered.

Used software and versions are mentioned in the script "scripts/taxonomy_assignment.sh" as well as in the yml-files under the directory envs.

Detailed Description:
"We compared all resulting matches of the MMseqs2 search (candidate loci) to the NCBI NR database (Sayers et al., 2023) using MMSeqs2 easy-taxonomy (lca-mode 4, tax-lineage 1, E-value 0.00001).
We removed all Figitidae and Polydnaviriformidae sequences from the NR database and maintained only candidate loci for which MMseqs2 computed a viral most recent common ancestor."
