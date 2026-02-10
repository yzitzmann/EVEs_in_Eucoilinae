# R script to identify overlaps between EVEs and transposable elements (TEs) October 24, 2025

# libraries used
library(S4Vectors)
library(GenomicRanges)
library(dplyr)
library(stringr)

# create input objects
path1 <- snakemake@input[[1]] # TE-positions
path2 <- snakemake@input[[2]] # EVE-positions
path3 <- snakemake@output[[1]] # output file

TEs <- read.delim(path1, header = F)
EVEs <- read.delim(path2, header = F)

colnames(TEs) <- c("query", "qlen", "tlen", "target", "qstart", "qend", "qframe", "tstart", "tend", "evalue", "tcov", "pident", "alnlen", "mismatch", "gapopen", "bits", "qaln")
colnames(EVEs) <- c("number", "query", "contig", "qlen", "tlen", "target", "Vlca", "Vfam", "Gstruc", "qstart", "qend", "qframe", "tstart", "tend", "evalue", "tcov", "pident", "alnlen", "mismatch", "gapopen", "bits", "qaln")

# change qstart and qend in EVEs to positions on whole contig
for(i in 1:nrow(EVEs)){
  EVEs$qstart[i] <- str_extract(EVEs$query[i], "(?<=:)[^-]+")
  EVEs$qend[i] <- str_extract(EVEs$query[i], "(?<=-)[^()]+")
}

# convert string to numeric
EVEs$qstart <- as.numeric(EVEs$qstart)
EVEs$qend <- as.numeric(EVEs$qend)

# ensure + strand orientation for TE- & EVE-loci
for(i in 1:nrow(TEs)){
  x <- TEs$qstart[i]
  y <- TEs$qend[i]
  
  if(x > y){
    TEs$qstart[i] <- y
    TEs$qend[i] <- x
  }
}
for(i in 1:nrow(EVEs)){
  x <- EVEs$qstart[i]
  y <- EVEs$qend[i]
  
  if(x > y){
    EVEs$qstart[i] <- y
    EVEs$qend[i] <- x
  }
}

# subset information
TEs <- data.frame(TEs$query, TEs$qstart, TEs$qend)
EVEs <- data.frame(EVEs$contig, EVEs$query, EVEs$qstart, EVEs$qend)

colnames(TEs) <- c("query", "qstart", "qend")
colnames(EVEs) <- c("contig", "query", "qstart", "qend")

# create GRanges object
TE_GRanges <- with(TEs, GRanges(seqnames = query, ranges = IRanges(start = qstart, end = qend)))
EVE_GRanges <- with(EVEs, GRanges(seqnames = contig, ranges = IRanges(start = qstart, end = qend), mcols = query))

# find overlaps between TEs and EVEs
overlaps <- subsetByOverlaps(EVE_GRanges, TE_GRanges, minoverlap = 1, ignore.strand = TRUE)

# output
write.table(overlaps, file = path3, append = FALSE, sep = " ", dec = ".", row.names = TRUE, col.names = TRUE, quote = F)
