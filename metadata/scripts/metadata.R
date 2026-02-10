# acquire metadata for all EVE cadidates                                     June 29, 2025

# access libraries
library(tibble)
library(dplyr)
library(stringr)

# set paths
path1 <- snakemake@input[[1]]
path2 <- snakemake@input[[2]]
path3 <- snakemake@input[[3]]
path4 <- snakemake@input[[4]]
path5 <- snakemake@input[[5]]
path6 <- snakemake@input[[6]]

path7 <- snakemake@output[[1]]
path8 <- snakemake@output[[2]]

# create objects
metadata <- read.csv(file = path1, header = F, sep = "\t", quote = "") # , quote = "" is new
families <- read.csv(file = path2, header = F, sep = " ", quote = "")
phages <- read.csv(file = path3, header = F, sep = " ")
fila <- read.csv(file = path4, header = F, sep = " ")
structure <- read.csv(file = path5, header = F, sep = "\t")
classes <- read.csv(file = path6, header = F, sep = " ", quote = "")

print("Metadata:")
head(metadata, 5)

print("Families:")
head(families, 5)

print("Phages:")
head(phages, 5)

print("Filamentoviridae:")
head(fila, 5)

print("Genomic Structure:")
head(structure, 5)

print("Classes:")
head(classes, 5)

# check for duplicates
print("Number of duplicates in metadata:")
print(sum(duplicated(metadata$V1)))

d <- sum(duplicated(metadata$V1))

print("Number of originals in metadata:")
print(nrow(metadata) - d)

# rename columns
colnames(metadata) <- c("query","qlen","tlen","target", "qstart", "qend", "qframe", "tstart", "tend", "evalue", "tcov", "pident", "alnlen", "mismatch", "gapopen", "bits", "qaln")

## family information
# reduce to desired data
families <- data.frame(families$V6, families$V18, families$V19, families$V20, families$V21)
colnames(families) <- c("Accession", "tax1", "tax2", "tax3", "tax4")

print("Head families:")
head(families, 5)

# remove unnecessary strings
taxonomy <- data.frame(families$tax1, families$tax2, families$tax3, families$tax4)
taxonomy[] <- lapply(taxonomy, gsub, pattern=';', replacement='')   # remove ;
taxonomy[] <- lapply(taxonomy, gsub, pattern='-', replacement='')   # remove -
taxonomy[] <- lapply(taxonomy, gsub, pattern=',', replacement='')   # remove ,
taxonomy[] <- lapply(taxonomy, gsub, pattern=')', replacement='')   # remove )
taxonomy[] <- lapply(taxonomy, gsub, pattern='[.]', replacement='') # remove .
taxonomy[] <- lapply(taxonomy, gsub, pattern='[(]', replacement='') # remove (

# identify family level by ending -dae
z <- nrow(taxonomy)
a <- 0

Family <- vector("character", z)

for(i in 1:z) {
  ifelse(grepl("dae", taxonomy$families.tax1[i]) == TRUE, Family[i] <- taxonomy$families.tax1[i], a <- a)
  ifelse(grepl("dae", taxonomy$families.tax2[i]) == TRUE, Family[i] <- taxonomy$families.tax2[i], a <- a)
  ifelse(grepl("dae", taxonomy$families.tax3[i]) == TRUE, Family[i] <- taxonomy$families.tax3[i], a <- a)
  ifelse(grepl("dae", taxonomy$families.tax4[i]) == TRUE, Family[i] <- taxonomy$families.tax4[i], a <- a)
}

# merge data to final dataframe
Accession <- families$Accession
tmp <- data.frame(Accession, Family)
taxonomy <- families
families <- tmp

print("Filter taxonomic data for family level:")
head(families, 5)

## add family information to metadata
# sort metadata and families alphabetically
metadata <- metadata[order(metadata$target),]
families <- families[order(families$Accession),]

# subset families for Accessions present in metadata
target <- metadata[!duplicated(metadata$target), ]
target <- data.frame(target$target)

x <- nrow(target)
present_accessions <- c()

for (i in 1:x) {
  sub <- subset(families, families$Accession == target$target.target[i])
  present_accessions <- rbind(present_accessions, sub)
}

## add family information
x <- nrow(metadata)
y <- nrow(present_accessions)

# set variables necessary
target <- metadata$target
acc <- present_accessions$Accession
fam <- present_accessions$Family
Vfam <- vector("character", x)

# fill in data
for (i in 1:x) {
  for(j in 1:y) {
    ifelse(target[i] == acc[j], Vfam[i] <- fam[j], a <- a)
  }
}

# merge data frames
Vfam <- data.frame(Vfam)
metadata_Vfam <- cbind(metadata, Vfam)
metadata_Vfam <- metadata_Vfam %>% relocate(Vfam, .after=target)

print("Add family information:")
head(metadata_Vfam, 5)

## class information
# reduce to desired data
classes <- data.frame(classes$V6, classes$V18, classes$V19, classes$V20, classes$V21)
colnames(classes) <- c("Accession", "tax1", "tax2", "tax3", "tax4")

print("Head Classes:")
head(classes, 5)

# # remove unnecessary strings
taxonomy <- data.frame(classes$tax1, classes$tax2, classes$tax3, classes$tax4)
taxonomy[] <- lapply(taxonomy, gsub, pattern=';', replacement='')   # remove ;
taxonomy[] <- lapply(taxonomy, gsub, pattern='-', replacement='')   # remove -
taxonomy[] <- lapply(taxonomy, gsub, pattern=',', replacement='')   # remove ,
taxonomy[] <- lapply(taxonomy, gsub, pattern=')', replacement='')   # remove )
taxonomy[] <- lapply(taxonomy, gsub, pattern='[.]', replacement='') # remove .
taxonomy[] <- lapply(taxonomy, gsub, pattern='[(]', replacement='') # remove (

# identify class level by ending -cetes
z <- nrow(taxonomy)
a <- 0

Class <- vector("character", z)

for(i in 1 :z) {
  ifelse(grepl("cetes", taxonomy$classes.tax1[i]) == TRUE, Class[i] <- taxonomy$classes.tax1[i], a <- a)
  ifelse(grepl("cetes", taxonomy$classes.tax2[i]) == TRUE, Class[i] <- taxonomy$classes.tax2[i], a <- a)
  ifelse(grepl("cetes", taxonomy$classes.tax3[i]) == TRUE, Class[i] <- taxonomy$classes.tax3[i], a <- a)
  ifelse(grepl("cetes", taxonomy$classes.tax4[i]) == TRUE, Class[i] <- taxonomy$classes.tax4[i], a <- a)
}

# merge data to final dataframe
Accession <- classes$Accession
tmp <- data.frame(Accession, Class)
classes <- tmp

print("Filter taxonomic data for class level:")
head(classes, 5)

## add class information to metadata
# sort metadata and classes alphabetically
metadata <- metadata[order(metadata$target),]
classes <- classes[order(classes$Accession),]

# subset classes for Accessions present in metadata
target <- metadata[!duplicated(metadata$target), ]
target <- data.frame(target$target)

x <- nrow(target)
present_accessions <- c()

for (i in 1:x) {
  sub <- subset(classes, classes$Accession == target$target.target[i])
  present_accessions <- rbind(present_accessions, sub)
}

## add class information
x <- nrow(metadata)
y <- nrow(present_accessions)

# set variables necessary
target <- metadata$target
acc <- present_accessions$Accession
cla <- present_accessions$Class
Vcla <- vector("character", x)

# fill in data
for (i in 1:x) {
  for(j in 1:y) {
    ifelse(target[i] == acc[j], Vcla[i] <- cla[j], a <- a)
  }
}

# merge data frames
Vcla <- data.frame(Vcla)
metadata_Vfam_Vcla <- cbind(metadata_Vfam, Vcla)
metadata_Vfam <- metadata_Vfam_Vcla %>% relocate(Vcla, .after=target)

print("Add class information:")
head(metadata_Vfam, 5)

# remove phages from data set
phages <- phages$V1
before <- nrow(metadata_Vfam)

phages_detected <- metadata_Vfam[metadata_Vfam$Vfam %in% phages,]
write.table(phages_detected, file = path7, append = FALSE, sep = "\t", dec = ".", row.names = TRUE, col.names = TRUE, quote = F)

metadata_Vfam <- metadata_Vfam[!metadata_Vfam$Vfam %in% phages,]

after <- nrow(metadata_Vfam)

print("Remove phages from data set:")
head(metadata_Vfam, 5)

print("Number of rows removed:")
print(before - after)

## remove query duplicates filtered by lowest evalue
# sort metadata by lowest evalue
sorted_metadata <- metadata_Vfam[order(metadata_Vfam$evalue),]

# remove duplicates from metadata
metadata_Vfam <- sorted_metadata[!duplicated(sorted_metadata$query), ]

print("Remove duplicates from metadata & Number of candidate loci:")
head(metadata_Vfam, 5)
print(nrow(metadata_Vfam))

# --> only the duplicate of a loci with the (shared) lowest e-value is maintained,
#     all other duplicates are discarded

# replace missing Vfam values with NA
tmp <- replace(metadata_Vfam$Vfam, metadata_Vfam$Vfam == "", "NA")
metadata_Vfam$Vfam <- tmp

print("Replace missing Vfam values with NA:")
head(metadata_Vfam, 5)

## add Filamentoviridae
# set variables
#fila <- rbind(fila, LbFV)
x <- nrow(fila)
y <- nrow(metadata_Vfam)

a <- 0

# add Filamentoviridae to metadata_Vfam
for (i in 1:x) {
  for (j in 1:y) {
    ifelse(fila$V1[i] == metadata_Vfam$target[j], metadata_Vfam$Vfam[j] <- "Filamentoviridae", a <- a)
  }
}

print("Add Filamentoviridae to metadata_Vfam:")
head(metadata_Vfam, 5)

## add genomic structure
#structure <- data.frame(structure$V1, structure$V2)
colnames(structure) <- c("Family", "Structure")

x <- nrow(structure)
y <- nrow(metadata_Vfam)
Gstruc <- vector("character", y)
a <- 0

for(i in 1:x) {
  for (j in 1:y) {
    ifelse(metadata_Vfam$Vfam[j] == structure$Family[i], Gstruc[j] <- structure$Structure[i], a <- a)
  }
}

Gstruc <- data.frame(Gstruc)

metadata_Vfam <- cbind(metadata_Vfam, Gstruc)
metadata_Vfam <- metadata_Vfam %>% relocate(Gstruc, .after=Vfam)

# replace missing Gstruc values with NA
tmp <- replace(metadata_Vfam$Gstruc, metadata_Vfam$Gstruc == "", "NA")
metadata_Vfam$Gstruc <- tmp

# add contig column and remove numbers in first column
contig <- vector("character", nrow(metadata_Vfam))

for(i in 1:nrow(metadata_Vfam)){
  contig[i] <- str_extract(metadata_Vfam$query[i], "[^:]+")
}

metadata_Vfam <- cbind(metadata_Vfam, contig)
metadata_Vfam <- metadata_Vfam %>% relocate(contig, .after=query)

colnames(metadata_Vfam) <- c("query", "contig", "qlen", "tlen", "target", "Vlca", "Vfam", "Gstruc", "qstart", "qend", "qframe", "tstart", "tend", "evalue", "tcov", "pident", "alnlen", "mismatch", "gapopen", "bits", "qaln")

print("Final table:")
head(metadata_Vfam, 5)

# create table output
write.table(metadata_Vfam, file = path8, append = FALSE, sep = "\t", dec = ".", row.names = TRUE, col.names = TRUE, quote = F)
