#                       EVE Analysis                        January 19, 2026

#library(renv)
#init()
#renv::snapshot()

# packages
library(here)
library(writexl)
library(ggplot2)
library(tidyverse)
library(car)
library(ape)
library(RRphylo)
library(ggtree)
library(ggstance)
library(showtext)
library(RColorBrewer)

# add input data
EVEs <- read.delim(here("data", "R_input", "all_EVEs.txt"), header = F)
genomes <- read.delim(here("data", "R_input", "genome_IDs_table.txt"), header = F)
tip_labels <- read.delim(here("data", "R_input", "species_decoder.txt"), header = F)
colnames(tip_labels) <- c("number", "label")

##### 1. clean data

# remove underscores
for(i in 1:nrow(tip_labels)){
  tip_labels[i,2] <- gsub("_", " ", tip_labels[i,2])
  tip_labels[i,2] <- gsub("Fi ", "Fi_", tip_labels[i,2])
}

# remove first column
EVEs$V1 <- NULL
colnames(EVEs) <- c("query", "contig", "qlen", "tlen", "target", "Vcla", "Vfam", "Gstruc", "qstart", "qend", "qframe", "tstart", "tend", "evalue", "tcov", "pident", "alnlen", "mismatch", "gapopen", "bits", "qaln")

# replace NA values with "unknown"
EVEs$Vfam <- EVEs$Vfam %>% replace_na("unknown")
EVEs$Gstruc <- EVEs$Gstruc %>% replace_na("unknown")

# check how many Filamentoviridae EVEs in C. longula
nrow(subset(EVEs, grepl("Fi-077", EVEs$query) & EVEs$Vfam == "Filamentoviridae"))

# remove Filamentoviridae EVEs from C. longula (exception: JmJC)
Cothonaspis_exceptions <- subset(EVEs, grepl("Fi-077", EVEs$query) & EVEs$target == "YP_009345615.1")
EVEs <- rbind(subset(EVEs, !(grepl("Fi-077", EVEs$query) & EVEs$Vfam == "Filamentoviridae")), Cothonaspis_exceptions)
nrow(EVEs)
# --> 1023 EVEs left

# create column with genome IDs & update genome IDs
Genome_ID <- as.data.frame(gsub(".*:","",EVEs$query))
colnames(Genome_ID) <- "ID"
x <- 0

for(i in 1:nrow(Genome_ID)) {
  for(j in 1:nrow(tip_labels)) {
    ifelse(Genome_ID$ID[i] == tip_labels$number[j], Genome_ID$ID[i] <- tip_labels$label[j], x <- x+1)  
  }
}

EVEs <- cbind(Genome_ID, EVEs)
write_xlsx(EVEs, here("data", "R_output", "EVE_dataset.xlsx"))

##### 2. EVE statistics

# E-value
qqPlot(EVEs$evalue)
shapiro.test(EVEs$evalue)
hist(EVEs$evalue)

median(EVEs$evalue)
min(EVEs$evalue)
max(EVEs$evalue)

# target coverage (relative coverage of target protein)
qqPlot(EVEs$tcov)
shapiro.test(EVEs$tcov)
hist(EVEs$tcov)

median(EVEs$tcov)
min(EVEs$tcov)
max(EVEs$tcov)

# alignment length
qqPlot(EVEs$alnlen)
shapiro.test(EVEs$alnlen)
hist(EVEs$alnlen)

median(EVEs$alnlen)
min(EVEs$alnlen)
max(EVEs$alnlen)

##### 3. Number of EVEs per genome

# create dataframe
species_EVEs <- data.frame(
  species = tip_labels$label,
  EVE_number = NA
  )

# fill in species occurences
for(i in 1:nrow(tip_labels)){
  species_EVEs[i, 2] <- sum(grepl(tip_labels[i, 2], EVEs$ID))
}

# check statistics
qqPlot(species_EVEs$EVE_number)
shapiro.test(species_EVEs$EVE_number)
hist(species_EVEs$EVE_number)

mean(species_EVEs$EVE_number)
sd(species_EVEs$EVE_number)
min(species_EVEs$EVE_number)
max(species_EVEs$EVE_number)

# save as excel-spreadsheet
write_xlsx(species_EVEs, here("data", "R_output", "EVEs_per_genome.xlsx"))

##### 4. Number of EVEs per viral family

# create dataframe
EVE_families <- data.frame(
  family = EVEs[!duplicated(EVEs$Vfam), ]$Vfam,
  EVE_number = NA
)

# fill in family occurence
for(i in 1:nrow(EVE_families)){
  EVE_families[i, 2] <- sum(grepl(EVE_families[i, 1], EVEs$Vfam))
}

# check statistics
nrow(EVE_families) - 1 # unknown family
qqPlot(EVE_families$EVE_number)
shapiro.test(EVE_families$EVE_number)
hist(EVE_families$EVE_number)

median(EVE_families$EVE_number)
min(EVE_families$EVE_number)
max(EVE_families$EVE_number)

# save dataframe as excel-spreadsheet
write_xlsx(EVE_families, here("data", "R_output", "EVEs_per_Vfamily.xlsx"))

##### 5. Genomic Structures (ssRNA, dsRNA, ssDNA, dsDNA) 

# add data on genomic structures
gstruc <- read.delim(here("data", "R_input", "virus_genome_structure.txt"), header = F)

# add structure data to data frame & remove unknown families
structure <- c()
EVE_families <- subset(EVE_families, EVE_families$family != "unknown")

for(i in 1:nrow(EVE_families)){
  structure[i] <- subset(gstruc, gstruc[, 1] == EVE_families$family[i])$V2
}

EVE_strc <- cbind(EVE_families, structure)

# check family numbers of genomic structures
sum(grepl("ssRNA", structure))/nrow(EVE_strc) * 100
sum(grepl("dsRNA", structure))/nrow(EVE_strc) * 100
sum(grepl("dsDNA", structure))/nrow(EVE_strc) * 100
sum(grepl("ssDNA", structure))/nrow(EVE_strc) * 100

# check EVE numbers of genomic structures
sum(subset(EVE_strc, EVE_strc[,3] == "ssRNA")$EVE_number)/sum(EVE_strc$EVE_number) * 100
sum(subset(EVE_strc, EVE_strc[,3] == "dsRNA")$EVE_number)/sum(EVE_strc$EVE_number) * 100
sum(subset(EVE_strc, EVE_strc[,3] == "dsDNA")$EVE_number)/sum(EVE_strc$EVE_number) * 100
sum(subset(EVE_strc, EVE_strc[,3] == "ssDNA")$EVE_number)/sum(EVE_strc$EVE_number) * 100

# create colors
colors <- c()

for(i in 1:nrow(EVE_strc)){
  if(EVE_strc[i, 3] == "dsDNA"){
    colors[i] <- "#B2182B"
  }
  if(EVE_strc[i, 3] == "ssDNA"){
    colors[i] <- "#D6604D"
  }
  if(EVE_strc[i, 3] == "dsRNA"){
    colors[i] <- "#4393C3"
  }
  if(EVE_strc[i, 3] == "ssRNA"){
    colors[i] <- "#2166AC"
  }
}

df <- data.frame(
  strc = c("dsDNA", "ssDNA", "dsRNA", "ssRNA"),
  clrs = c("#B2182B", "#D6604D", "#4393C3", "#2166AC")
)

family_colors <- setNames(df$clrs, df$strc)
EVE_strc <- cbind(EVE_strc, colors)

# make some modifications to family labels
EVE_strc[EVE_strc[,1] == "Malacoherpesviridae", 1] <- "Malacoherpesv."
EVE_strc[EVE_strc[,1] == "Orthomyxoviridae", 1] <- "Orthomyxov."
EVE_strc[EVE_strc[,1] == "Phycodnaviridae", 1] <- "Phycodnav."
EVE_strc[EVE_strc[,1] == "Filamentoviridae", 1] <- "Filamentov."

# create order for legend items
EVE_strc$structure <- factor(EVE_strc$structure, levels = c("dsDNA", "ssDNA", "dsRNA", "ssRNA"))

# make Arial font available
showtext_auto()

# plot
jpeg(filename = here("plots" ,"Vfamilies.jpeg"),
     width = 75, height = 55, units = "cm", quality = 75, res = 72)

ggplot(EVE_strc, aes(x = reorder(family, -EVE_number), y = EVE_number, fill = structure)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = family_colors) +
  theme_minimal() +
  theme(text = element_text(family = "Arial"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 25),
        axis.text.x = element_text(angle = 60, hjust = 0.5, size = 18),
        axis.text.y = element_text(size = 18),
        legend.key.size = unit(1.5, "cm"),
        legend.position = c(0.95, 0.9),
        legend.text = element_text(size = 18),
        legend.title = element_blank()
  ) +
  geom_text(aes(label = EVE_number, color = structure), vjust = -0.5, size = 7, show.legend = FALSE) +
  scale_color_manual(values = family_colors) +
  scale_x_discrete(expand = expansion(mult = c(0.0, 0.025))) +
  ylab("Number of EVEs")

dev.off()

# vector graphic
library(export)

Vfam_plot <-
  ggplot(EVE_strc, aes(x = reorder(family, -EVE_number), y = EVE_number, fill = structure)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = family_colors) +
  theme_minimal() +
  theme(text = element_text(family = "Arial"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(angle = 60, hjust = 0.6, size = 8),
        axis.text.y = element_text(size = 8),
        legend.key.size = unit(0.5, "cm"),
        legend.position = c(0.92, 0.9),
        legend.text = element_text(size = 8),
        legend.title = element_blank()
  ) +
  geom_text(aes(label = EVE_number, color = structure), vjust = -0.5, size = 3, show.legend = FALSE) +
  scale_color_manual(values = family_colors) +
  scale_x_discrete(expand = expansion(mult = c(0.0, 0.025))) +
  ylab("Number of EVEs")

graph2vector(x = Vfam_plot, file = here("plots", "Vfamilies"), type ="SVG", font = "sans", aspectr = 1.5)

##### 6. Number of EVEs per species and viral family (excluding unknown families)

# remove unknown family EVEs
subset_EVEs <- subset(EVEs, EVEs$Vfam != "unknown")
subset_EVE_families <- subset(EVE_families, EVE_families$family != "unknown")

# create dataframe
occurences <- data.frame()

# loop through all species and viral families counting occurrences of all combinations in EVE list
for(i in 1:nrow(species_EVEs)){
  curr_species <- data.frame(
    species = rep(species_EVEs[i, 1], each = length(subset_EVE_families$family)),
    families = subset_EVE_families$family,
    EVE_number = NA
  )
  
  for(j in 1:nrow(curr_species)){
    curr_species[j, 3] <- sum(subset_EVEs$ID == curr_species[j, 1] & subset_EVEs$Vfam == curr_species[j, 2])
  }
  
  curr_species <- curr_species[curr_species$EVE_number != 0, ]
  occurences <- rbind(occurences, curr_species)
}

# save as excel
write_xlsx(occurences, here("data", "R_output", "EVE_occurences.xlsx"))

##### 7. create species phylogeny

# add tree
tree <- read.tree(file = here("data", "R_input", "renamed_euco_treesearch_aa_full.treefile"))
tree$tip.label <- gsub("_", " ", tree$tip.label)
tree$tip.label <- gsub("Fi ", "Fi_", tree$tip.label)

# root tree
rtree <- root(tree, outgroup = c("Fi_094 Aegilips sp", "Fi_093 Anacharis immunis"), resolve.root = T)
is.rooted(rtree)

# resolve polytomy at root
resolved_tree <- fix.poly(rtree, type = "collapse", node = 81)

# show bootstrap support
resolved_tree$node.label <- sub("/.*", "", resolved_tree$node.label) 
plot(resolved_tree, show.node.label = TRUE)

##### 8. plot EVEs overview

# make Arial font available
showtext_auto()

# create ggtree
my_tree <- ggtree(resolved_tree, size = 0.65) + geom_tiplab(align = TRUE, size = 4, offset = 0.0, family = 'Arial', fontface = 'italic')

# create color vector
display.brewer.pal(n = 9, name = 'Set1')
colors <- brewer.pal(n = 8, name = "Set1")
colors <- colorRampPalette(colors)(39)
colors <- rev(colors)

# save as jpeg
jpeg(filename = here("plots", "EVEs_overview.jpeg"),
    width = 75, height = 55, units = "cm", quality = 75, res = 72)

print(facet_plot(my_tree + xlim_tree(0.75), panel = '', data = occurences, geom = geom_barh, 
                 mapping = aes(x = EVE_number, fill = families), stat = 'identity') +
        scale_fill_manual(values = colors) +
        theme_minimal() +
        theme(strip.background = element_blank(),
              strip.text.x = element_blank(),
              legend.key.size = unit(1.0, 'cm'),
              legend.position =c(0.1, 0.8),
              legend.title = element_blank(), 
              legend.text = element_text(size = 12),
              axis.title.x = element_text(size = 22, hjust = 0.837),
              axis.text.x = element_text(size = 22),
              axis.line.x = element_line(size = 1.5),
              axis.text.y = element_blank(),
              text = element_text(family = "Arial")) +
        xlab("Number of EVEs"))


dev.off()

# vector graphic
library(export)
my_tree <- ggtree(resolved_tree, size = 0.1) +
  geom_tiplab(align = TRUE, size = 2.0, linesize = 0.25, offset = 0.0, family = 'Arial', fontface = "italic")

EVEs_overview <- facet_plot(my_tree + xlim_tree(0.8), panel = '', data = occurences, geom = geom_barh, mapping = aes(x = EVE_number, fill = families), stat = 'identity') +
  scale_fill_manual(values = colors) +
  theme_minimal() +
  theme(strip.background = element_blank(),
        strip.text.x = element_blank(),
        legend.key.height = unit(3.0, 'mm'),
        legend.key.width = unit(2.4, 'mm'),
        legend.key.spacing.y = unit(-0.5, 'mm'),
        legend.position =c(0.08, 0.73),
        legend.title = element_blank(), 
        legend.text = element_text(size = 4),
        axis.title.x = element_text(size = 8, hjust = 0.837),
        axis.text.x = element_text(size = 8),
        axis.line.x = element_line(size = 0.3),
        axis.text.y = element_blank(),
        text = element_text(family = "Arial")) +
  xlab("Number of EVEs")

graph2vector(x = EVEs_overview, file = here("plots", "EVEs_overview"), type ="SVG", font = "sans", aspectr = 2.0)

##### 9. Filamentoviridae heatmap

# add IQTREE confirmed Fila EVEs 
phylo_EVEs <- read.delim(here("data", "R_input", "Fila_phylogeny_EVEs.txt"), header = F)
phylo_EVEs$V1 <- NULL
colnames(phylo_EVEs) <- c("query", "contig", "qlen", "tlen", "target", "Vcla", "Vfam", "Gstruc", "qstart", "qend", "qframe", "tstart", "tend", "evalue", "tcov", "pident", "alnlen", "mismatch", "gapopen", "bits", "qaln")

# create Genome_ID
IDs <- as.data.frame(gsub(".*:","", phylo_EVEs$query))
colnames(IDs) <- "ID"

x <- 0
for(i in 1:nrow(IDs)) {
  for(j in 1:nrow(tip_labels)) {
    ifelse(IDs[i, 1] == tip_labels$number[j], IDs[i, 1] <- tip_labels$label[j], x <- x+1)  
  }
}

phylo_EVEs <- cbind(IDs, phylo_EVEs)

# add decoder for Filamentoviridae proteins
fila_decode <- read.delim(here("data", "R_input", "Filamentoviridae_decoder.txt"), header = F)
targets <- fila_decode$V2

# subset for Filamentoviridae EVEs
Fila_EVEs <- subset(EVEs, EVEs$Vfam == "Filamentoviridae")

# create heatmap matrix
heatmap_matrix <- data.frame(matrix(nrow = 41, ncol = length(targets)))
colnames(heatmap_matrix) = targets
genomes <- as.data.frame(tip_labels$label)
heatmap_matrix <- cbind(genomes, heatmap_matrix)

# find genome matches for each EVE 
full_matches <- vector("list", length(targets))
names(full_matches) <- targets
half_matches <- vector("list", length(targets))
names(half_matches) <- targets

for(i in seq_along(targets)){
  full_matches[[i]] <- subset(Fila_EVEs, Fila_EVEs$target == targets[i])$ID
  half_matches[[i]] <- subset(phylo_EVEs, phylo_EVEs$target == targets[i])$ID
}

# add presence of each Fila_EVE to heatmap_matrix
for(i in 1:length(full_matches)){
  for(j in 1:length(full_matches[[i]])){
    for(k in 1:nrow(heatmap_matrix)){
      ifelse(full_matches[[i]][j] == heatmap_matrix[k, 1], heatmap_matrix[k, i+1] <- 1, x <- 0)
    }
  }
}

# add presence of each phylo_EVE to heatmap_matrix
for(i in 1:length(half_matches)){
  for(j in 1:length(half_matches[[i]])){
    for(k in 1:nrow(heatmap_matrix)){
      ifelse(half_matches[[i]][j] == heatmap_matrix[k, 1], heatmap_matrix[k, i+1] <- 0.7, x <- 0)
    }
  }
}

# add phylogeny confirmed EVEs lost in taxonomy filter
lef5 <- read.delim(here("data", "R_input", "lef5.txt"), header = F)$V1
orf108 <- read.delim(here("data", "R_input", "LbFVorf108.txt"), header = F)$V1

heatmap_matrix$LbFV_lef5[grepl(paste(lef5, collapse ="|"), heatmap_matrix[,1])] <- 0.5
heatmap_matrix$YP_009345712.1[grepl(paste(orf108, collapse ="|"), heatmap_matrix[,1])] <- 0.5

# adjust data frame structure
rownames(heatmap_matrix) <- heatmap_matrix$`tip_labels$label`
heatmap_matrix$`tip_labels$label` <- NULL

# replace NA with 0
heatmap_matrix[is.na(heatmap_matrix)] <- 0

# change column names & remove empty columns/ merge columns
colnames(heatmap_matrix) <- fila_decode$V1
heatmap_matrix$LbFVJmJC1 <- heatmap_matrix$LbFVJmJC1 + heatmap_matrix$LbFVJmJC2
heatmap_matrix[15, 17] <- 1.0
heatmap_matrix$LbFVJmJC2 <- NULL
heatmap_matrix$LbFVorf87 <- heatmap_matrix$`PcFVorf87-like` + heatmap_matrix$LbFVorf87
heatmap_matrix$`PcFVorf87-like` <- NULL
heatmap_matrix$LbFVorf105 <- NULL
heatmap_matrix$`LbFVorf19(38k)` <- NULL
heatmap_matrix$`LbFVorf106(Odv-e66)` <- NULL
heatmap_matrix$`LbFVorf2(integrase)` <- NULL

# change order of columns
heatmap_matrix <- select(heatmap_matrix, LbFVorf5, LbFVorf10, `LbFVorf38(lef-5)`, `LbFVorf60(lcat)`, `LbFVorf68(helicase2)`, LbFVorf72, `LbFVorf78(lef-9)`, LbFVorf83, `LbFVorf85(Ac81)`, LbFVorf87, LbFVorf92, LbFVorf94, `LbFVorf96(lef-8)`, `LbFVorf107(lef-4)`, LbFVorf108, LbFVDNApol, LbFVJmJC1)

# save as excel
write_xlsx(heatmap_matrix, here("data", "R_output", "ancestral_event_EVEs.xlsx"))

tips_to_keep <- grep("Fi_037 Rhoptromeris heptoma|Fi_034 Rhoptromeris heptoma|Fi_035 Rhoptromeris sp|Fi_036 Rhoptromeris villosa|Fi_040 Trichoplasta sp|Fi_077 Cothonaspis longula|Fi_027 Leptopilina heterotoma|Fi_026 Leptopilina fimbriata|Fi_047 Maacynips sp|Fi_042 Trybliographa sp 1|Fi_043 Trybliographa sp 2|USNMENT01557301 Leptolamina sp", resolved_tree$tip.label, value = TRUE)
ancestral_event <- keep.tip(resolved_tree, tips_to_keep)

# plot heatmap
my_tree <- ggtree(ancestral_event, size = 0.65) +
  geom_tiplab(align = TRUE, size = 7, offset = 0.0, family = 'Arial', fontface = "italic") +
  #geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.02, size = 5) +
  geom_treescale(x = 0, y = 11, width = 0.2, linesize = 1, fontsize = 7)

support_nodes <- subset(my_tree$data, !isTip)

my_tree <- my_tree + geom_point(data = support_nodes, size = 7, color = "black")

# jpeg
jpeg(filename = here("plots", "ancestral_event_heatmap.jpeg"),
     width = 75, height = 55, units = "cm", quality = 75, res = 72)

gheatmap(my_tree, heatmap_matrix, offset = 0.42, width = 2.4, low = "white", high = "#800",
         color = "black",
         colnames_position = "top",
         font.size = 6,
         colnames_offset_y = -0.3,
         colnames_offset_x = 0,
         colnames_angle = 45,
         hjust = 0) +
  theme(legend.position = 'none',
        text = element_text(family = "Arial")) +
  vexpand(0.05) +
  hexpand(0.02)

dev.off()

# vector graphic
library(export)

my_tree <- ggtree(ancestral_event, size = 0.2) +
  geom_tiplab(align = TRUE, size = 2, linesize = 0.2, offset = 0.01, family = 'Arial', fontface = "italic") +
  #geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.015, size = 1.5) +
  geom_treescale(x = 0, y = 12, width = 0.2, linesize = 0.2, fontsize = 2)

support_nodes <- subset(my_tree$data, !isTip)

my_tree <- my_tree + geom_point(data = support_nodes, size = 1.5, color = "black")

my_heatmap <- gheatmap(my_tree, heatmap_matrix, offset = 0.28, width = 2.0, low = "white", high = "#800",
                       color = "black",
                       colnames_position = "top",
                       font.size = 2,
                       colnames_offset_y = -0.3,
                       colnames_offset_x = 0,
                       colnames_angle = 45,
                       hjust = 0) +
  theme(legend.position = 'none',
        text = element_text(family = "Arial")) +
  vexpand(0.1) +
  hexpand(0.03)

graph2vector(x = my_heatmap, file = here("plots", "ancestral_event_heatmap"), type ="SVG", font = "Arial", aspectr = 1.6)


##### 10. other viral family heatmaps (Nudiviridae example)

# subset for family EVEs
one_family_EVEs <- subset(EVEs, EVEs$Vfam == "Nudiviridae")
targets <- unique(one_family_EVEs$target)

# create dataframe
heatmap_matrix <- data.frame(matrix(nrow = 41, ncol = length(targets)))
colnames(heatmap_matrix) = targets
genomes <- as.data.frame(tip_labels$label)
heatmap_matrix <- cbind(genomes, heatmap_matrix)

# subset genomes of each protein
matches <- vector("list", length(targets))
names(matches) <- targets

for(i in seq_along(targets)){
  matches[[i]] <- subset(one_family_EVEs, one_family_EVEs$target == targets[i])$ID
}

# fill in data for each protein
for(i in 1:length(matches)){
  for(j in 1:length(matches[[i]])){
    for(k in 1:nrow(heatmap_matrix)){
      ifelse(matches[[i]][j] == heatmap_matrix[k, 1], heatmap_matrix[k, i+1] <- 1, x <- 0)
    }
  }
}

# adjust data frame structure
rownames(heatmap_matrix) <- heatmap_matrix$`tip_labels$label`
heatmap_matrix$`tip_labels$label` <- NULL

# replace NA with 0
heatmap_matrix[is.na(heatmap_matrix)] <- 0

# save as excel
write_xlsx(heatmap_matrix, here("data", "R_output", "Nudiviridae_EVEs.xlsx"))

# plot heatmap
my_tree <- ggtree(resolved_tree, size = 0.65) + geom_tiplab(align = TRUE, size = 6, offset = 0.005, family = 'Arial', fontface = "italic") +
  geom_treescale(x = 0, y = 40, width = 0.2, linesize = 1, fontsize = 6)

# jpeg
jpeg(filename = here("plots", "Nudiviridae_heatmap.jpeg"),
     width = 75, height = 55, units = "cm", quality = 75, res = 72)

gheatmap(my_tree, heatmap_matrix, offset = 0.5, width = 2.0, low = "white", high = "#4393C3",
         color = "black",
         colnames_position = "top",
         font.size = 6,
         colnames_offset_y = 0,
         colnames_offset_x = 0,
         colnames_angle = 45,
         hjust = 0) +
  theme(legend.position = 'none',
        text = element_text(family = "Arial")) +
  vexpand(0.07) +
  hexpand(0.0)

dev.off()
