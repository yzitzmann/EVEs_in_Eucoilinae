*** ReadME phylogenetic_reconstruction ***
Contents of this directory represent the sevenths step of the workflow.
This directory is split into the subdirectories "clustering", "phylogeny" and "phylogeny_lost_EVEs".

The script "clustering/scripts/final_clustering.sh" form clusters between similar virus sequences and EVEs as well as Filamentoviridae EVE candidates for phylogenetic reconstruction.
The script "phylogeny/scripts/final_phylo.sh" reconstructs the phylogeny of clusters containing Filamentoviridae EVEs and free-living virus sequences.
The script "phylogeny_lost_EVEs/scripts/new_phylo.sh" reconstructs the phylogeny of clusters to which sequences erroneously lost during the taxonomy filter were added.

Used software and versions are mentioned in the scripts listed above as well as in the yml-files under the directories envs.

Detailed Description:
"We reconstructed the evolution of ancestral event EVEs in Eucoilini and Trichoplastini by creating clusters of the virus protein database and identified EVEs as well as unconfirmed ancestral event EVE candidates
(Steinegger & Söding, 2017). Then, we aligned all clusters containing endogenized Filamentoviridae proteins with Clustal Omega (Sievers & Higgins, 2014) and created maximum likelihood phylogenies using IQ-TREE (Nguyen et al. 2015)."
