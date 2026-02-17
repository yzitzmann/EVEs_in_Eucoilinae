# **EVEs in Eucoilinae**
---
February 10, 2026

This repository contains the scripts used for the detection of endogenous viral elements (EVEs) in Eucoilinae genomes published in ... (doi: ...).

The directories represent the steps of the workflow. All steps were conducted on the LIB-HPC using the workflow management system Snakemake (Mölder et al., 2021) as well as the python library pandas (McKinney, 2010). 

## **Software**  
McKinney W (2010) Data Structures for Statistical Computing in Python. Python in Science Conference, 56–61.
https://doi.org/10.25080/Majora-92bf1922-00a  

Mölder F, Jablonski KP, Letcher B, Hall MB, Tomkins-Tinch CH, Sochat V, Forster J, Lee S, Twardziok SO, Kanitz A, Wilm A, Holtgrewe M, Rahmann S, Nahnsen S, Köster J (2021)
Sustainable data analysis with Snakemake [version 2; peer review: 2 approved]. F1000Research, 10(33).
https://doi.org/10.12688/f1000research.29032.2

The order in which the steps of the workflow were executed is as follows:  
  **1. viral_protein_database  
  2. homology_search  
  3. taxonomy_filter  
  4. metadata  
  5. TE_filter  
  6. endogenization_test**  
     a. BUSCO_confirmation  
     b. seq_depth_confirmation  
     c. TE_and_depth  
     d. EVEs  
  **8. phylogenetic_reconstruction**  
     a. clustering  
     b. phylogeny  
     c. phylogeny_lost_EVEs  
  **10. data_analysis**  

All directories contain ReadMe-files describing the steps in more detail.  
Used software and their versions are listed in the ReadMe as well as yml-files and were implemented via miniforge (24.3.0).  

## **Detailed Workflow Description**  
We created a custom virus protein dataset consisting of 141,451 sequences based on the NCBI reference sequence viral protein database (Goldfarb et al., 2025). Next, we searched for EVEs using a workflow based on the pipeline created by Guinet et al. (2023) and documented on Zenodo (...). In short, we acquired metadata on candidate loci after taxonomic filtering with a Mmseqs2 search (Steinegger & Söding, 2017) using our loci as queries. Additionally, taxonomic data on free-living virus matches as well as their genomic structures was gathered from NCBI (Goldfarb et al., 2025) and the International Council on Virus Taxonomy (Black et al., 2026). To exclude transposons from our EVE candidate dataset, we searched for transposons by conducting an Mmseqs2 search against the RepeatPeps library (Storer et al., 2021) and removed all EVEs overlapping with transposons using GenomicRanges (Lawrence et al., 2013).

Finally, we used three endogenization criteria to discriminate between EVEs and free-living virus sequences accepting candidates which meet at least one criteria:

1. A contig containing a candidate locus also contains a hymenopteran benchmarking universal single-copy ortholog (BUSCO).
2. A contig containing a candidate locus exhibits a sequencing depth within the 15th to 85th percentile of the BUSCO-containing contigs  
   (Benjamini-Hochberg adjusted).
3. A contig containing a candidate locus exhibits a sequencing depth within the 5th to 95th percentile of the BUSCO-containing contigs 
   (Benjamini-Hochberg adjusted) as well as a non-overlapping transposon.

To apply our criteria, we used a BUSCO search (Tegenfeldt et al., 2025) against the Hymenoptera odb12 database as well as bwa-mem2 (Vasimuddin et al., 2019) and samtools (Danecek et al., 2021) to infer the average contig sequencing depth. BUSCO-containing contigs were compared to those containing candidates and controlled for the false discovery rate (Benjamini & Hochberg, 1995). We reconstructed the evolution of ancestral event EVEs in ‘Eucoilini’ + Trichoplastini by creating clusters of the virus protein database and identified EVEs as well as unconfirmed ancestral event EVE candidates including those lost during taxonomy filtering. Then, we aligned all clusters containing endogenized Filamentoviridae proteins with Clustal Omega (Sievers & Higgins, 2014) and created maximum likelihood phylogenies using IQ-TREE 3 (Wong et al., 2025) with ModelFinder (Kalyaanamoorthy et al., 2017) and ultrafast bootstrap approximation (Hoang et al., 2018). Due to a lack of support for Cothonaspis longula EVEs originating in the ancestral event and a large quantity of 32 exclusively sequencing depth-confirmed Filamentoviridae EVEs, we looked for signs of viral infection in C. longula. A MMseqs2 search (Steinegger & Söding, 2017) of Eucoilini and Trichoplastini genomes against the Filamentoviridae subset detected more than twice as many matches to non-fragmented Filamentoviridae proteins at non-overlapping loci (58) compared to Eucoilini and Trichoplastini genomes (median = 20, max = 35). Thus, we decided to remove sequencing depth-confirmed C. longula Filamentoviridae EVEs which were not additionally confirmed by our IQ-TREE 3 analysis. Analysis and visualization of the final EVE dataset was conducted in R Version 4.4.0 (R Core Team, 2024) using the tidyverse (Wickham et al., 2019) as well as packages car (Fox & Weisberg, 2019), ape (Paradis & Schliep, 2019), phytools (Revell, 2024), RRphylo (Castiglione et al., 2020), ggplot2 (Wickham, 2016), ggstance (Henry et al., 2024), ggtree (Guangchuang, 2022) and RColorBrewer (Neuwirth, 2022).

## **References**
Benjamini, Yoav, and Yosef Hochberg. “Controlling the False Discovery Rate: A Practical and 
   Powerful Approach to Multiple Testing.” Journal of the Royal Statistical Society Series B: Statistical Methodology 57, no. 1 (1995): 289–300. https://doi.org/10.1111/j.2517-6161.1995.tb02031.x.
Black, Eden J., C. Steve Powell, Donald M. Dempsey, R. Curtis Hendrickson, Logan R. Mims, and 
   Elliot J. Lefkowitz. “Virus Taxonomy: The Database of the International Committee on Taxonomy of Viruses.” Nucleic Acids Research 54, no. D1 (2026): D776–89. https://doi.org/10.1093/nar/gkaf1159.
Castiglione, Silvia, Carmela Serio, Martina Piccolo, et al. “The Influence of Domestication, 
   Insularity and Sociality on the Tempo and Mode of Brain Size Evolution in Mammals.” Biological Journal of the Linnean Society 132, no. 1 (2021): 221–31. https://doi.org/10.1093/biolinnean/blaa186.
Danecek, Petr, James K. Bonfield, Jennifer Liddle, et al. “Twelve Years of SAMtools and BCFtools.” 
   GigaScience 10, no. 2 (2021): giab008. https://doi.org/10.1093/gigascience/giab008.
Fox, John, and Sanford Weisberg. An R Companion to Applied Regression. 3rd ed. Sage, 2019.
   https://www.john-fox.ca/Companion/.
Goldfarb, T., Kodali, V. K., Pujar, S., Brover, V., Robbertse, B., Farrell, C. M., Oh, D.-H., 
   Astashyn, A., Ermolaeva, O., Haddad, D., Hlavina, W., Hoffman, J., Jackson, J. D., Joardar, V. S., Kristensen, D., Masterson, P., McGarvey, K. M., McVeigh, R., Mozes, E., … Murphy, T. D. (2025). NCBI RefSeq: Reference sequence standards through 25 years of curation and annotation. Nucleic Acids Research, 53(D1), D243–D257. https://doi.org/10.1093/nar/gkae1038
Guangchuang, Yu. Data Integration, Manipulation and Visualization of Phylogenetic Trees. 1st ed. 
   Chapman and Hall/CRC, 2022. https://doi.org/doi:10.1201/9781003279242.
Guinet, Benjamin, David Lepetit, Sylvain Charlat, et al. “Endoparasitoid Lifestyle Promotes 
   Endogenization and Domestication of dsDNA Viruses.” eLife 12 (June 2023): e85993. https://doi.org/10.7554/eLife.85993.
Henry, Lionel, Hadley Wickham, and Winston Chang. “Ggstance: Horizontal ‘ggplot2’ Components. R 
   Package Version 0.3.7.” 2024. https://CRAN.R-project.org/package=ggstance.
Hoang, Diep Thi, Olga Chernomor, Arndt Von Haeseler, Bui Quang Minh, and Le Sy Vinh. “UFBoot2: 
   Improving the Ultrafast Bootstrap Approximation.” Molecular Biology and Evolution 35, no. 2 (2018): 518–22. https://doi.org/10.1093/molbev/msx281.
Kalyaanamoorthy, Subha, Bui Quang Minh, Thomas K. F. Wong, Arndt Von Haeseler, and Lars S. Jermiin. 
   “ModelFinder: Fast Model Selection for Accurate Phylogenetic Estimates.” Nature Methods 14, no. 6 (2017): 587–89. https://doi.org/10.1038/nmeth.4285.
Lawrence, Michael, Wolfgang Huber, Hervé Pagès, et al. “Software for Computing and Annotating 
   Genomic Ranges.” PLoS Computational Biology 9, no. 8 (2013): e1003118. https://doi.org/10.1371/journal.pcbi.1003118.
Neuwirth E. (2022). RColorBrewer: ColorBrewer Palettes. R package version 1.1-3,
  <https://CRAN.R-project.org/package=RColorBrewer>
Paradis, Emmanuel, and Klaus Schliep. “Ape 5.0: An Environment for Modern Phylogenetics and 
   Evolutionary Analyses in R.” Bioinformatics 35, no. 3 (2019): 526–28. https://doi.org/10.1093/bioinformatics/bty633.
R Core Team. “R: A Language and Environment for Statistical Computing.” R Foundation for 
   Statistical Computing, 2024. https://www.R-project.org/.
Revell, Liam J. “Phytools 2.0: An Updated R Ecosystem for Phylogenetic Comparative Methods (and 
   Other Things).” PeerJ 12 (January 2024): e16505. https://doi.org/10.7717/peerj.16505.
Sievers, Fabian, and Desmond G. Higgins. “Clustal Omega.” Current Protocols in Bioinformatics 48, 
   no. 1 (2014). https://doi.org/10.1002/0471250953.bi0313s48.
Steinegger, Martin, and Johannes Söding. “MMseqs2 Enables Sensitive Protein Sequence Searching for 
   the Analysis of Massive Data Sets.” Nature Biotechnology 35, no. 11 (2017): 1026–28. https://doi.org/10.1038/nbt.3988.
Storer, Jessica, Robert Hubley, Jeb Rosen, Travis J. Wheeler, and Arian F. Smit. “The Dfam 
   Community Resource of Transposable Element Families, Sequence Models, and Genome Annotations.” Mobile DNA 12, no. 1 (2021): 2. https://doi.org/10.1186/s13100-020-00230-y.
Tegenfeldt, Fredrik, Dmitry Kuznetsov, Mosè Manni, Matthew Berkeley, Evgeny M. Zdobnov, and Evgenia 
   V. Kriventseva. “OrthoDB and BUSCO Update: Annotation of Orthologs with Wider Sampling of Genomes.” Nucleic Acids Research 53, no. D1 (2025): D516–22. https://doi.org/10.1093/nar/gkae987.
Vasimuddin, M., S. Misra, H. Li, and S. Aluru. “Efficient Architecture-Aware Acceleration of 
   BWA-MEM for Multicore Systems.” 2019, 314–24. https://doi.org/doi:%252010.1109/IPDPS.2019.00041.
Wickham, Hadley. Ggplot2: Elegant Graphics for Data Analysis.
   Springer-Verlag, 2016.
Wickham, Hadley, Mara Averick, Jennifer Bryan, et al. “Welcome to the Tidyverse.” Journal of Open 
   Source Software 4, no. 43 (2019): 1686. https://doi.org/10.21105/joss.01686.
Wong, Thomas K. F., Nhan Ly-Trong, Huaiyan Ren, et al. “IQ-TREE 3: Phylogenomic Inference Software 
   Using Complex Evolutionary Models.” Preprint, EcoEvoRxiv, April 7, 2025. https://doi.org/10.32942/X2P62N.