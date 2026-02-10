# libraries used
library(S4Vectors)
library(GenomicRanges)
library(dplyr)

# create input objects
path1 <- snakemake@input[[1]] # mmseqs2-search output file
path2 <- snakemake@output[[1]] # R-script output file

loci <- read.table(path1, header = F, sep = '')
colnames(loci) <- c("query", "qlen", "tlen", "target", "qstart", "qend", "qframe" ,"tstart", "tend", "evalue", "tcov", "pident", "alnlen", "mismatch", "gapopen", "bits", "qaln")

# sort qstart < qend
for(i in 1:nrow(loci)){
  x <- loci$qstart[i]
  y <- loci$qend[i]
  
  if(x > y){
    loci$qstart[i] <- y
    loci$qend[i] <- x
  }

  # replace qframe with '+' and '-' strand indications
  ifelse(loci$qframe[i] < 0, loci$qframe[i] <- "-", loci$qframe[i] <- "+")
}

# create GRanges object 
loci_GRanges <- with(loci, GRanges(seqnames = query, ranges = IRanges(start = qstart, end = qend), target = target, strand = qframe, len = qlen))

# merge all overlapping sequences
merged_loci_GRanges <- reduce(loci_GRanges)

# transform back to data frame
merged_loci_GRanges <- data.frame(merged_loci_GRanges)

# take query and qlen from initial table (loci) and remove all query duplicates
sub_qlen_tab <- loci %>% select(query, qlen)
sub_qlen_tab <- sub_qlen_tab[!duplicated(sub_qlen_tab$query), ]

# create GRanges object equivalent to merged_loci_GRanges dataframe
genes_viral <- with(merged_loci_GRanges, GRanges(seqnames = seqnames, ranges = IRanges(start = start, end = end)))

# create strand2 column in GRanges object equivalent to strand
genes_viral$strand2 <- merged_loci_GRanges$strand

# create datframe equivalent to GRanges object and merge this df with sub_qlen_tab
genes_viraldf <- data.frame(genes_viral)
genes_viraldf <- merge(y = genes_viraldf, x = sub_qlen_tab, by.y = 'seqnames', by.x = "query")
# --> genes_viraldf now includes query lengths (qlen)

# delete 'strand' column, instead label 'strand2' as 'strand'
genes_viraldf$strand <- NULL
names(genes_viraldf)[names(genes_viraldf)=="strand2"] <- "strand"

write.table(genes_viraldf, file = path2, append = FALSE, sep = " ", dec = ".", row.names = TRUE, col.names = TRUE, quote = F)






