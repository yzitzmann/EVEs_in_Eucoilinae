# Plotting EVE phylogenies                                     December 30, 2025

## removing objects from global environment
rm(list = ls())

# libraries
library(ape)
library(phytools)
library(tidyverse)

# upload treefiles & save in list (tree_list)
tree_directory <- "E:/master_thesis/paper/data/Filamentoviridae_iqtree_output/candidates_lost_EVEs_bootstrap"
tree_files <- list.files(tree_directory, pattern = "\\.contree", full.names = TRUE)
tree_list <- lapply(tree_files, read.tree)

# remove trees not containing ancestral event EVEs
keep_tips <- read.delim("E:/master_thesis/paper/data/R_input/Filamentoviridae_decoder.txt", header = F)$V2
keep <- sapply(tree_list, function(rndm) any(rndm$tip.label %in% keep_tips))
EVE_trees <- tree_list[keep]

# root trees
root_trees <- lapply(EVE_trees, midpoint.root)

'
# subset trees for relevant virus sequences and EVEs
for(i in 1:length(root_trees)){
  tips_to_keep <- grep("YP_009345609.1|YP_009345614.1|YP_009345676.1|YP_009345687.1|YP_009345691.1|YP_009345698.1|YP_009345712.1|YP_009345664.1|YP_009345711.1|YP_009345642.1|YP_009345700.1|YP_009345682.1|YP_009345662.1|YP_009345672.1|YP_009345696.1|YP_009345689.1|YP_009345617.1|WNK26554.1|YP_009345709.1|YP_009345710.1|YP_009345606.1|YP_009345623.1|YP_009345615.1|LbFV_lef5|Fi", root_trees[[i]]$tip.label, value = TRUE)
  root_trees[[i]] <- keep.tip(root_trees[[i]], tips_to_keep)
}
'

# change tip labels of ...
# ... virus proteins
label_virus <- read.delim("E:/master_thesis/paper/data/R_input/Filamentoviridae_decoder.txt", header = F)

for(i in 1:length(root_trees)){
  for(j in 1:length(root_trees[[i]]$tip.label)){
    for(k in 1:nrow(label_virus)){
      ifelse(root_trees[[i]]$tip.label[j] == label_virus[k,2], root_trees[[i]]$tip.label[j] <- label_virus[k,1], root_trees[[i]]$tip.label[j] <- root_trees[[i]]$tip.label[j])
    }
  }
}

# ... species
label_species <- read.delim("E:/master_thesis/paper/data/R_input/species_decoder_new.txt", header = F)

for(i in 1:nrow(label_species)){                             # remove underscores
  label_species[i,2] <- gsub("_", " ", label_species[i,2])
  label_species[i,2] <- gsub("Fi ", "Fi_", label_species[i,2])
}

EVEs <- read.delim('E:/master_thesis/paper/data/R_input/all_EVEs.txt', header = F)
Filamentoviridae <- gsub("\\(-\\)", "", subset(EVEs, EVEs$V8 == "Filamentoviridae")$V2) %>%
  gsub("\\(\\+\\)", "", .) %>%
  sub(":.*:", " ", .)

a <- 0

for(i in 1:length(Filamentoviridae)){
  for(j in 1:nrow(label_species)){
    ifelse(grepl(label_species[j,1], Filamentoviridae[i]), Filamentoviridae[i] <- gsub("Fi-.*$", label_species[j,2], Filamentoviridae[i]), a <- a)
  }
}

for(i in 1:length(root_trees)){
  root_trees[[i]]$tip.label <- sub("^((?:[^_]*_){2})[^_]*_(?:[^_]*_)", "\\1", root_trees[[i]]$tip.label)
  root_trees[[i]]$tip.label <- sub("^((?:[^_]*_){1}[^_]*)_", "\\1 ", root_trees[[i]]$tip.label)
  root_trees[[i]]$tip.label <- gsub("Fi_", "Fi-", root_trees[[i]]$tip.label)
}

for(i in 1:length(root_trees)){
  for(j in 1:length(root_trees[[i]]$tip.label)){
    for(k in 1:nrow(label_species)){
      ifelse(grepl(label_species[k,1], root_trees[[i]]$tip.label[j]), root_trees[[i]]$tip.label[j] <- gsub("Fi-.*$", label_species[k,2], root_trees[[i]]$tip.label[j]), a <- a)
    }
  }
}

# plot trees
for(i in 1:length(root_trees)){
  lapply(root_trees[i], plot, show.node.label = TRUE)
}

##### plot nicely (Filamentoviridae diversity removed)

# make Arial font available
library(showtext)
showtext_auto()

library(ggtree)
library(RRphylo)

# include EVE or EVE candidate data
all_tip_labels <- unlist(lapply(root_trees, "[[", "tip.label"))

tip_colors <- unique(data.frame(
  label = all_tip_labels,
  color = ifelse(all_tip_labels %in% Filamentoviridae, "#800", "#aaa")
))

# LbFVorf87
plot(root_trees[[1]])
#root_trees[[1]] <- drop.tip(root_trees[[1]], "LbFV-orf87-like protein")
ggtree(root_trees[[1]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[1]]$edge.length) * 1.75)
# --> node 16  

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf87.jpeg",
    width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[1]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.1, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[1]]$edge.length) * 1.6) +
  theme(legend.position = "None") +
  geom_highlight(node = 16, fill = "#800", alpha = 0.25, extend = 1.75) +
  scale_color_identity()

dev.off()

# helicase2
plot(root_trees[[2]])
#root_trees[[2]] <- drop.tip(root_trees[[2]], "Melanips opacus")
ggtree(root_trees[[2]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[1]]$edge.length) * 1.75)
# --> node 18

jpeg(filename = "D:/master_thesis/paper/plots/test/helicase2.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[2]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[2]]$edge.length) * 2) +
  theme(legend.position = "None") +
  geom_highlight(node = 18, fill = "#800", alpha = 0.25, extend = 0.9) +
  scale_color_identity()

dev.off()

# LbFVorf10
plot(root_trees[[3]])
ggtree(root_trees[[3]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 1.75)
# --> node 9

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf10.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[3]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[3]]$edge.length) * 1.3) +
  theme(legend.position = "None") +
  geom_highlight(node = 9, fill = "#800", alpha = 0.25, extend = 1.1) +
  scale_color_identity()

dev.off()

# LbFVorf108
plot(root_trees[[4]])
ggtree(root_trees[[4]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 1.75)
# --> node 15

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf108.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[4]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[4]]$edge.length) * 2.0) +
  theme(legend.position = "None") +
  geom_highlight(node = 15, fill = "#800", alpha = 0.25, extend = 0.7) +
  scale_color_identity()

dev.off()

# lef8
plot(root_trees[[5]])
ggtree(root_trees[[5]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 1.75)
# --> node 14

jpeg(filename = "D:/master_thesis/paper/plots/test/lef8.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[5]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[5]]$edge.length) * 1.5) +
  theme(legend.position = "None") +
  geom_highlight(node = 14, fill = "#800", alpha = 0.25, extend = 0.6) +
  scale_color_identity()

dev.off()

# LbFVorf92
plot(root_trees[[6]])
ggtree(root_trees[[6]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 1.75)
# --> node 15

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf92.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[6]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[6]]$edge.length) * 1.35) +
  theme(legend.position = "None") +
  geom_highlight(node = 15, fill = "#800", alpha = 0.25, extend = 0.8) +
  scale_color_identity()

dev.off()

# LbFVorf83
plot(root_trees[[7]])
#root_trees[[7]] <- drop.tip(root_trees[[7]], "Endecameris sp.")
ggtree(root_trees[[7]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[7]]$edge.length) * 1.75)
# --> node 15

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf83.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[7]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[7]]$edge.length) * 1.7) +
  theme(legend.position = "None") +
  geom_highlight(node = 15, fill = "#800", alpha = 0.25, extend = 1.0) +
  scale_color_identity()

dev.off()

# JmJC
plot(root_trees[[8]])
#root_trees[[8]] <- drop.tip(root_trees[[8]], "Glauraspidia fennica")
#root_trees[[8]] <- drop.tip(root_trees[[8]], "Disorygma depile")
ggtree(root_trees[[8]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[8]]$edge.length) * 1.75)
# --> node 14

jpeg(filename = "D:/master_thesis/paper/plots/test/JmJC.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[8]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[8]]$edge.length) * 1.8) +
  theme(legend.position = "None") +
  geom_highlight(node = 14, fill = "#800", alpha = 0.25, extend = 0.9) +
  scale_color_identity()

dev.off()

# lef5
plot(root_trees[[9]])
ggtree(root_trees[[9]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[9]]$edge.length) * 1.75)
# --> node 20

jpeg(filename = "D:/master_thesis/paper/plots/test/lef5.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[9]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[9]]$edge.length) * 1.4) +
  theme(legend.position = "None") +
  geom_highlight(node = 20, fill = "#800", alpha = 0.25, extend = 0.7) +
  scale_color_identity()

dev.off()

# 38k
plot(root_trees[[10]])
ggtree(root_trees[[10]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[10]]$edge.length) * 1.75)
# --> no node

jpeg(filename = "D:/master_thesis/paper/plots/test/38k.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[10]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[10]]$edge.length) * 2.0) +
  theme(legend.position = "None") +
  scale_color_identity()

dev.off()

# integrase
plot(root_trees[[11]])
ggtree(root_trees[[11]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[11]]$edge.length) * 1.75)
# --> no node

jpeg(filename = "D:/master_thesis/paper/plots/test/integrase.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[11]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[11]]$edge.length) * 1.5) +
  theme(legend.position = "None") +
  scale_color_identity()

dev.off()

# LbFVorf5
plot(root_trees[[12]])
ggtree(root_trees[[12]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[12]]$edge.length) * 1.75)
# --> node 19

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf5.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[12]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[12]]$edge.length) * 1.7) +
  theme(legend.position = "None") +
  geom_highlight(node = 19, fill = "#800", alpha = 0.25, extend = 1.05) +
  scale_color_identity()

dev.off()

# LbFVDNApol
plot(root_trees[[13]])
ggtree(root_trees[[13]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[13]]$edge.length) * 1.75)
# --> node 14

jpeg(filename = "D:/master_thesis/paper/plots/test/DNApol.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[13]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[13]]$edge.length) * 2.0) +
  theme(legend.position = "None") +
  geom_highlight(node = 14, fill = "#800", alpha = 0.25, extend = 0.5) +
  scale_color_identity()

dev.off()

# lef4
plot(root_trees[[14]])
ggtree(root_trees[[14]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[14]]$edge.length) * 4.0)
# --> node 16

jpeg(filename = "D:/master_thesis/paper/plots/test/lef4.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[14]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[14]]$edge.length) * 2.75) +
  theme(legend.position = "None") +
  geom_highlight(node = 16, fill = "#800", alpha = 0.25, extend = 0.9) +
  scale_color_identity()

dev.off()

# lef9
plot(root_trees[[15]])
ggtree(root_trees[[15]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[15]]$edge.length) * 3.0)
# --> node 16

jpeg(filename = "D:/master_thesis/paper/plots/test/lef9.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[15]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[15]]$edge.length) * 2.3) +
  theme(legend.position = "None") +
  geom_highlight(node = 16, fill = "#800", alpha = 0.25, extend = 0.5) +
  scale_color_identity()

dev.off()

# Ac81
plot(root_trees[[16]])
#root_trees[[16]] <- drop.tip(root_trees[[16]], "cf. Foersterhomorus sp.")
ggtree(root_trees[[16]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[16]]$edge.length) * 3.0)
# --> node 14

jpeg(filename = "D:/master_thesis/paper/plots/test/Ac81.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[16]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[16]]$edge.length) * 1.9) +
  theme(legend.position = "None") +
  geom_highlight(node = 14, fill = "#800", alpha = 0.25, extend = 0.5) +
  scale_color_identity()

dev.off()

# lcat
plot(root_trees[[17]])
ggtree(root_trees[[17]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[17]]$edge.length) * 3.0)
# --> node 15

jpeg(filename = "D:/master_thesis/paper/plots/test/lcat.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[17]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[17]]$edge.length) * 2.0) +
  theme(legend.position = "None") +
  geom_highlight(node = 15, fill = "#800", alpha = 0.25, extend = 0.75) +
  scale_color_identity()

dev.off()

# LbFVorf72
plot(root_trees[[18]])
ggtree(root_trees[[18]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[18]]$edge.length) * 3.0)
# --> node 11

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf72.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[18]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[18]]$edge.length) * 1.3) +
  theme(legend.position = "None") +
  geom_highlight(node = 11, fill = "#800", alpha = 0.25, extend = 0.75) +
  scale_color_identity()

dev.off()

# LbFVorf94
plot(root_trees[[19]])
ggtree(root_trees[[19]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[19]]$edge.length) * 3.0)
# --> node 12

jpeg(filename = "D:/master_thesis/paper/plots/test/LbFVorf94.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[19]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[19]]$edge.length) * 1.7) +
  theme(legend.position = "None") +
  geom_highlight(node = 12, fill = "#800", alpha = 0.25, extend = 0.8) +
  scale_color_identity()

dev.off()

# odve66
plot(root_trees[[20]])
ggtree(root_trees[[20]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[20]]$edge.length) * 3.0)
# --> no node

jpeg(filename = "D:/master_thesis/paper/plots/test/odv-e66.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[20]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.1, size = 7) +
  xlim(0, max(root_trees[[20]]$edge.length) * 1.5) +
  theme(legend.position = "None") +
  scale_color_identity()

dev.off()

##### plot nicely (Filamentoviridae diversity included)

# make Arial font available
library(showtext)
showtext_auto()

library(ggtree)
library(RRphylo)

# include EVE or EVE candidate data
all_tip_labels <- unlist(lapply(root_trees, "[[", "tip.label"))

tip_colors <- unique(data.frame(
  label = all_tip_labels,
  color = ifelse(all_tip_labels %in% Filamentoviridae, "#800", "#aaa")
))

# LbFVorf87
plot(root_trees[[1]], show.node.label = TRUE)
#root_trees[[1]] <- drop.tip(root_trees[[1]], "LbFV-orf87-like protein")
ggtree(root_trees[[1]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[1]]$edge.length) * 1.75)
# --> node 23

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf87.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[1]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.1, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[1]]$edge.length) * 1.6) +
  theme(legend.position = "None") +
  geom_highlight(node = 23, fill = "#800", alpha = 0.25, extend = 2.5) +
  scale_color_identity()

dev.off()

# helicase2
plot(root_trees[[2]])
#root_trees[[2]] <- drop.tip(root_trees[[2]], "Melanips opacus")
ggtree(root_trees[[2]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[1]]$edge.length) * 1.75)
# --> node 22

jpeg(filename = "E:/master_thesis/paper/plots/test/helicase2.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[2]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[2]]$edge.length) * 1.5) +
  theme(legend.position = "None") +
  geom_highlight(node = 22, fill = "#800", alpha = 0.25, extend = 1.2) +
  scale_color_identity()

dev.off()

# LbFVorf10
plot(root_trees[[3]])
ggtree(root_trees[[3]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 1.75)
# --> node 9

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf10.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[3]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[3]]$edge.length) * 1.6) +
  theme(legend.position = "None") +
  geom_highlight(node = 9, fill = "#800", alpha = 0.25, extend = 1.5) +
  scale_color_identity()

dev.off()

# LbFVorf108
plot(root_trees[[4]])
ggtree(root_trees[[4]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 3.0)
# --> node 11

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf108.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[4]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[4]]$edge.length) * 2.1) +
  theme(legend.position = "None") +
  geom_highlight(node = 11, fill = "#800", alpha = 0.25, extend = 1.0) +
  scale_color_identity()

dev.off()

# lef8
plot(root_trees[[5]])
ggtree(root_trees[[5]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 2.5)
# --> node 25

jpeg(filename = "E:/master_thesis/paper/plots/test/lef8.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[5]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.05, size = 7) +
  xlim(0, max(root_trees[[5]]$edge.length) * 2.6) +
  theme(legend.position = "None") +
  geom_highlight(node = 25, fill = "#800", alpha = 0.25, extend = 2.6) +
  scale_color_identity()

dev.off()

# LbFVorf92
plot(root_trees[[6]])
ggtree(root_trees[[6]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[3]]$edge.length) * 3.5)
# --> node 27

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf92.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[6]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.04, size = 7) +
  xlim(0, max(root_trees[[6]]$edge.length) * 2.1) +
  theme(legend.position = "None") +
  geom_highlight(node = 27, fill = "#800", alpha = 0.25, extend = 2.0) +
  scale_color_identity()

dev.off()

# LbFVorf83
plot(root_trees[[7]])
#root_trees[[7]] <- drop.tip(root_trees[[7]], "Endecameris sp.")
ggtree(root_trees[[7]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[7]]$edge.length) * 1.75)
# --> node 15

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf83.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[7]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[7]]$edge.length) * 1.6) +
  theme(legend.position = "None") +
  geom_highlight(node = 15, fill = "#800", alpha = 0.25, extend = 1.5) +
  scale_color_identity()

dev.off()

# JmJc
plot(root_trees[[8]])
ggtree(root_trees[[8]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[9]]$edge.length) * 1.75)
# --> node 20

jpeg(filename = "E:/master_thesis/paper/plots/test/JmJC.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[8]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[8]]$edge.length) * 1.8) +
  theme(legend.position = "None") +
  geom_highlight(node = 20, fill = "#800", alpha = 0.25, extend = 1.0) +
  scale_color_identity()

dev.off()

# lef5
plot(root_trees[[9]])
ggtree(root_trees[[9]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[9]]$edge.length) * 1.75)
# --> node 20

jpeg(filename = "E:/master_thesis/paper/plots/test/lef5.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[9]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[9]]$edge.length) * 1.4) +
  theme(legend.position = "None") +
  geom_highlight(node = 20, fill = "#800", alpha = 0.25, extend = 0.8) +
  scale_color_identity()

dev.off()

# LbFVorf5
plot(root_trees[[12]])
ggtree(root_trees[[12]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[10]]$edge.length) * 3.5)
# --> node 21

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf5.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[12]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.04, size = 6) +
  xlim(0, max(root_trees[[12]]$edge.length) * 1.4) +
  theme(legend.position = "None") +
  geom_highlight(node = 21, fill = "#800", alpha = 0.25, extend = 1.75) +
  scale_color_identity()

dev.off()

# DNApol
plot(root_trees[[13]])
ggtree(root_trees[[13]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[11]]$edge.length) * 3.0)
# --> node 23

jpeg(filename = "E:/master_thesis/paper/plots/test/DNApol.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[13]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[13]]$edge.length) * 1.4) +
  theme(legend.position = "None") +
  geom_highlight(node = 23, fill = "#800", alpha = 0.25, extend = 0.85) +
  scale_color_identity()

dev.off()

# lef4
plot(root_trees[[14]])
ggtree(root_trees[[14]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[12]]$edge.length) * 1.75)
# --> node 20

jpeg(filename = "E:/master_thesis/paper/plots/test/lef4.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[14]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[14]]$edge.length) * 1.5) +
  theme(legend.position = "None") +
  geom_highlight(node = 20, fill = "#800", alpha = 0.25, extend = 1.2) +
  scale_color_identity()

dev.off()

# lef9
plot(root_trees[[15]])
ggtree(root_trees[[15]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[13]]$edge.length) * 3.0)
# --> node 28

jpeg(filename = "E:/master_thesis/paper/plots/test/lef9.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[15]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.05, size = 7) +
  xlim(0, max(root_trees[[15]]$edge.length) * 3.2) +
  theme(legend.position = "None") +
  geom_highlight(node = 28, fill = "#800", alpha = 0.25, extend = 2.0) +
  scale_color_identity()

dev.off()

# Ac81
plot(root_trees[[16]])
ggtree(root_trees[[16]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[14]]$edge.length) * 2.0)
# --> node 39

jpeg(filename = "E:/master_thesis/paper/plots/test/Ac81.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[16]]) %>% collapse(node = 44)  %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[16]]$edge.length) * 2.5) +
  theme(legend.position = "None") +
  geom_highlight(node = 39, fill = "#800", alpha = 0.25, extend = 2.1) +
  scale_color_identity()

dev.off()

# lcat
plot(root_trees[[17]])
ggtree(root_trees[[17]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[15]]$edge.length) * 3.0)
# --> node 26

jpeg(filename = "E:/master_thesis/paper/plots/test/lcat.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[17]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.04, size = 7) +
  xlim(0, max(root_trees[[17]]$edge.length) * 2.4) +
  theme(legend.position = "None") +
  geom_highlight(node = 26, fill = "#800", alpha = 0.25, extend = 1.4) +
  scale_color_identity()

dev.off()

# LbFVorf72
plot(root_trees[[18]])
#root_trees[[16]] <- drop.tip(root_trees[[16]], "cf. Foersterhomorus sp.")
ggtree(root_trees[[18]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[16]]$edge.length) * 3.0)
# --> node 11

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf72.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[18]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[18]]$edge.length) * 1.5) +
  theme(legend.position = "None") +
  geom_highlight(node = 11, fill = "#800", alpha = 0.25, extend = 1.0) +
  scale_color_identity()

dev.off()

# LbFVorf94
plot(root_trees[[19]])
ggtree(root_trees[[19]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 3, offset = 0.1) +
  geom_text2(aes(subset = !isTip, label = node, size = 3)) +
  xlim(0, max(root_trees[[17]]$edge.length) * 2.0)
# --> node 21

jpeg(filename = "E:/master_thesis/paper/plots/test/LbFVorf94.jpeg",
     width = 120, height = 70, units = "cm", res = 70)

ggtree(root_trees[[19]]) %<+% tip_colors +
  geom_tiplab(aes(label = label, color = color), align = TRUE, size = 10, offset = 0.05, family = "Arial") +
  geom_text2(aes(subset = !isTip, label = label), family = "Arial", nudge_x = 0.03, size = 7) +
  xlim(0, max(root_trees[[19]]$edge.length) * 1.6) +
  theme(legend.position = "None") +
  geom_highlight(node = 21, fill = "#800", alpha = 0.25, extend = 1.3) +
  scale_color_identity()

dev.off()