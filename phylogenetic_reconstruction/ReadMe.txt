*** ReadME phylogenetic_reconstruction ***
Contents of this directory represent the sevenths step of the workflow.
This directory is split into the subdirectories "clustering", "phylogeny" and "phylogeny_lost_EVEs".

The script "clustering/scripts/final_clustering.sh" form clusters between similar virus sequences and EVEs as well
as Filamentoviridae EVE candidates for phylogenetic reconstruction.
The script "phylogeny/scripts/final_phylo.sh" reconstructs the phylogeny of clusters containing Filamentoviridae
EVEs and free-living virus sequences.
The script "phylogeny_lost_EVEs/scripts/new_phylo.sh" reconstructs the phylogeny of clusters to which sequences
erroneously lost during the taxonomy filter were added.

Used software and versions are mentioned in the scripts listed above as well as in the yml-files under the
directories envs.

Detailed Description:
"We reconstructed the evolution of ancestral event EVEs in Eucoilini and Trichoplastini by creating clusters of the
virus protein database and identified EVEs as well as unconfirmed ancestral event EVE candidates including those
lost during taxonomy filtering (Steinegger & Söding, 2017). Then, we aligned all clusters containing endogenized
Filamentoviridae proteins with Clustal Omega (Sievers & Higgins, 2014) and created maximum likelihood phylogenies
using IQ-TREE 3 (Wong et al., 2025) with ModelFinder (Kalyaanamoorthy et al., 2017) and ultrafast bootstrap
approximation (Hoang et al., 2018)."

Software:
Camacho C., Coulouris G., Avagyan V., Ma N., Papadopoulos J., Bealer K., Madden (2009). TLBLAST+: architecture and
	applications. BMC Bioinformatics 10(421). https://doi.org/10.1186/1471-2105-10-421
oang, Diep Thi, Olga Chernomor, Arndt Von Haeseler, Bui Quang Minh, and Le Sy Vinh. “UFBoot2: Improving the
	Ultrafast Bootstrap Approximation.” Molecular Biology and Evolution 35, no. 2 (2018): 518–22.
	https://doi.org/10.1093/molbev/msx281.
Kalyaanamoorthy, Subha, Bui Quang Minh, Thomas K. F. Wong, Arndt Von Haeseler, and Lars S. Jermiin. “ModelFinder:
	Fast Model Selection for Accurate Phylogenetic Estimates.” Nature Methods 14, no. 6 (2017): 587–89.
	https://doi.org/10.1038/nmeth.4285.
Shen W., Le S., Li Y., Hu F. (2016). SeqKit: A Cross-Platform and Ultrafast Toolkit for FASTA/Q File Manipulation.
	PLOS ONE, 11(10), e0163962. https://doi.org/10.1371/journal.pone.0163962 
Sievers F., Higgins D.G. (2014). Clustal Omega. Current Protocols in Bioinformatics, 48(1), 3.13.1-3.13.16.
	https://doi.org/10.1002/0471250953.bi0313s48
Steinegger M., Söding J. (2017). MMseqs2 enables sensitive protein sequence searching for the analysis of massive
	data sets. Nature Biotechnology, 35, 1026–1028. https://doi.org/10.1038/nbt.3988
Wong, Thomas K. F., Nhan Ly-Trong, Huaiyan Ren, et al. “IQ-TREE 3: Phylogenomic Inference Software 
   Using Complex Evolutionary Models.” Preprint, EcoEvoRxiv, April 7, 2025. https://doi.org/10.32942/X2P62N.
