**ReadMe EVEs in Eucoilinae** February 10, 2026

This repository contains the scripts used for the detection of endogenous viral elements (EVEs) in Eucoilinae genomes published in ... (doi: ...).

The directories represent the steps of the workflow. All steps were conducted on the LIB-HPC using the workflow management system Snakemake (Mölder et al., 2021) as well as the python library pandas (McKinney, 2010). 

*Software*
McKinney W (2010) Data Structures for Statistical Computing in Python. Python in Science Conference, 56–61.
  https://doi.org/10.25080/Majora-92bf1922-00a  
Mölder F, Jablonski KP, Letcher B, Hall MB, Tomkins-Tinch CH, Sochat V, Forster J, Lee S, Twardziok SO, Kanitz A, Wilm A, Holtgrewe M, Rahmann S, Nahnsen S, Köster J (2021)
  Sustainable data analysis with Snakemake [version 2; peer review: 2 approved]. F1000Research, 10(33).
  https://doi.org/10.12688/f1000research.29032.2

The order in which the steps of the workflow were executed is as follows:
>  1. viral_protein_database  
>  2. homology_search  
>  3. taxonomy_filter  
>  4. metadata  
>  5. TE_filter  
>  6. endogenization_test  
     a) BUSCO_confirmation  
     b) seq_depth_confirmation  
     c) TE_and_depth  
     d) EVEs
>  8. phylogenetic_reconstruction  
     a) clustering  
     b) phylogeny  
     c) phylogeny_lost_EVEs  
>  10. data_analysis  

All directories contain ReadMe-files describing the steps in more detail.  
Used software and their versions are listed in the ReadMe as well as yml-files and were implemented via miniforge (24.3.0).  

*Detailed Workflow Description*  
We created a custom virus protein dataset consisting of 141,451 sequences based on the NCBI reference sequence viral protein database (O’Leary et al., 2016). Given our research question, we excluded bacteriophages as well as Polydnaviriformidae and complemented our dataset with 371 sequences of Filamentoviridae (NCBI: PRJNA964713) as well as 40 sequences of Ichnovirus Structural Protein Encoding Regions (Volkoff et al., 2010). We searched for EVEs using a workflow based on the pipeline created by Guinet et al. (2023). In short, we acquired metadata on candidate loci after taxonomic filtering with a Mmseqs2 search (Steinegger & Söding, 2017) using our loci as queries. Additionally, taxonomic data on free-living virus matches as well as their genomic structures was gathered from NCBI (O’Leary et al., 2016) and the International Council on Virus Taxonomy (ICTV, Lefkowitz et al., 2018). To exclude transposons from our EVE candidate dataset, we searched for transposons by conducting an Mmseqs2 search against the RepeatPeps library (Flynn et al. 2020) and removed all EVEs overlapping with transposons using GenomicRanges (Lawrence et al. 2013).  
Finally, we used three endogenization criteria to discriminate between EVEs and free-living virus sequences accepting candidates which meet at least one criteria:  
>  1. A contig containing a candidate locus also contains a hymenopteran benchmarking universal single-copy ortholog (BUSCO).  
>  2. A contig containing a candidate locus exhibits a sequencing depth within the 15th to 85th percentile of the BUSCO-containing contigs (Benjamini-Hochberg adjusted).  
>  3. A contig containing a candidate locus exhibits a sequencing depth within the 5th to 95th percentile of the BUSCO-containing contigs (Benjamini-Hochberg adjusted) as well as a non-overlapping transposon.  

To identify EVEs with the first criterion, we ran a BUSCO search against the Hymenoptera odb12 database and matched contigs with at least one fragmented or complete BUSCO to the candidate-containing contigs. For the second and third criterion, we inferred the average sequencing depth of contigs containing BUSCOs (null distribution) as well as candidate loci either using bwa-mem2 (Vasimuddin et al., 2019) and samtools (Danecek et al., 2021), or from the genome assembly. We compared the null distribution to candidate contigs, controlled the false discovery rate (Benjamini & Hochberg, 1995) and accepted candidates with a minimum p-value of 0.15 as well as 0.05 and a transposon respectively.

We reconstructed the evolution of ancestral event EVEs in Eucoilini and Trichoplastini by creating clusters of the virus protein database and identified EVEs as well as unconfirmed ancestral event EVE candidates. Then, we aligned all clusters containing endogenized Filamentoviridae proteins with Clustal Omega (Sievers & Higgins, 2014) and created maximum likelihood phylogenies using IQ-TREE (Nguyen et al. 2015). Due to a lack of support for *Cothonaspis longula* EVEs originating in the ancestral event and a large quantity of 32 exclusively sequencing depth-confirmed Filamentoviridae EVEs, we looked for signs of viral infection in *C*. *longula*. A MMseqs2 search (Steinegger & Söding, 2017) of Eucoilini and Trichoplastini genomes against the Filamentoviridae subset detected more than twice as many matches to non-fragmented Filamentoviridae proteins at non-overlapping loci (58) compared to Eucoilini and Trichoplastini genomes (mean = 23.4, max = 36). Thus, we decided to remove sequencing depth-confirmed *C*. *longula* Filamentoviridae EVEs which were not additionally confirmed by our IQ-TREE analysis.
