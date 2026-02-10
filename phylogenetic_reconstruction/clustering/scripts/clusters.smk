# Snakemake script to form separate clusters

import pandas as pd

# wildcard list
cluster_IDS_table=pd.read_csv("/home/yzitzmann/paper/phylogenetic_reconstruction/clustering/data/cluster_IDs.txt",header=None)
list_cluster_IDs=list(cluster_IDS_table[0])

rule all:
        input:
                expand("output/separate_clusters/{cluster_ID}.tsv", cluster_ID = list_cluster_IDs)

# create files for each cluster
rule separate_clusters:
        input:
                clusters="output/labels_clusters.tsv"
        output:
                separate_clusters="output/separate_clusters/{cluster_ID}.tsv"
        threads:
                1
        shell:
                """
                # write clusters in one line into separate files
                grep {wildcards.cluster_ID} {input.clusters} | cut -f 2 | paste -s > {output.separate_clusters}
                """
