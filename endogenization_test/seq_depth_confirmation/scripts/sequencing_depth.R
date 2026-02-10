# Script to calculate (FDR-corrected) p-values            August 2, 2025

# set paths
path1 <- snakemake@input[[1]]
path2 <- snakemake@input[[2]]
path3 <- snakemake@output[[1]]
path4 <- snakemake@output[[2]]
path5 <- snakemake@output[[3]]

# create objects
BUSCO_depth <- read.csv(file = path1, header = F, sep = "\t")
candidate_depth <- read.csv(file = path2, header = F, sep = "\t")

# 1. calculate p-values for candidate-containing nodes
print("BUSCO:")
head(BUSCO_depth)

print("Candidates:")
head(candidate_depth)

# check if dataframes
print("Is BUSCO a dataframe?")
is.data.frame(BUSCO_depth)

print("Is candidates a dataframe?")
is.data.frame(candidate_depth)

# modify BUSCO and candidates
BUSCO_depth <- data.frame(BUSCO_depth$V1, BUSCO_depth$V7)
colnames(BUSCO_depth) <- c("Contig", "sequencing_depth")

candidate_depth <- data.frame(candidate_depth$V1, candidate_depth$V7)
colnames(candidate_depth) <- c("Contig", "sequencing_depth")

# sort BUSCO and candidates by ascending sequencing depth
candidate_depth <- candidate_depth[order(candidate_depth$sequencing_depth), ]
BUSCO_depth <- BUSCO_depth[order(BUSCO_depth$sequencing_depth), ]

# calculate number of smaller depths in BUSCO-nodes compared to candidate-nodes
BUSCO.vec <- BUSCO_depth$sequencing_depth
candidate.vec <- candidate_depth$sequencing_depth

smaller_BUSCO_contigs <- findInterval(candidate.vec, BUSCO.vec)

# add number of smaller depths to candidate_depth
smaller_BUSCO_contigs <- data.frame(smaller_BUSCO_contigs)
candidate_depth <- cbind(candidate_depth, smaller_BUSCO_contigs)

# calculate p-value (percentage of more extreme depths in BUSCO-contigs) for every candidate node
x <- nrow(BUSCO_depth)
y <- nrow(candidate_depth)

p_value <- vector("integer", y)

for(i in 1:y) {
  p_value[i] <- candidate_depth$smaller_BUSCO_contigs[i]/x
  ifelse(p_value[i] > 0.5, p_value[i] <- 1-p_value[i], p_value[i] <- p_value[i])
}

p_value

# add p_value to candidates_depth
Contig <- candidate_depth$Contig
Candidates_p_value <- data.frame(Contig, p_value)

# 2. calculate the FDR-corrected p-values for candidate-containing contigs
BH_p <- p.adjust(p_value, method="BH")
Candidates_adjusted_p <- data.frame(Contig, p_value, BH_p)

print("final data frame:")
head(Candidates_adjusted_p)

# 3. Enforce thresholds
# enforce endo-requirement of 15% to 85% percentile
endo_15_85 <- subset(Candidates_adjusted_p, BH_p >= 0.15)
write.table(endo_15_85, file = path3, append = FALSE, sep = "\t", dec = ".", row.names = FALSE, col.names = TRUE, quote = F)

# enforce endo-requirement of 5% to 95%
endo_5_95 <- subset(Candidates_adjusted_p, BH_p < 0.15 & BH_p >= 0.05)
write.table(endo_5_95, file = path4, append = FALSE, sep = "\t", dec = ".", row.names = FALSE, col.names = TRUE, quote = F)

# also report all FDR-corrected p-values
write.table(Candidates_adjusted_p, file = path5, append = FALSE, sep = "\t", dec = ".", row.names = FALSE, col.names = TRUE, quote = F)
