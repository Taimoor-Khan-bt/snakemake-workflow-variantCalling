include: "rules/map_rg_sort_index.smk"
include: "rules/mark_duplicates.smk"
include: "rules/bqsr.smk"
include: "rules/collect_metrices.smk"
include: "rules/variant_detection.smk"
include: "rules/variant_filteration.smk"
include: "rules/variant_annotation.smk"
include: "rules/extract_anno.smk"


configfile: "config.yaml"

rule all:
    input:
        expand("{sample}/bam/{sample}_sorted.bam", sample = config["samples"]),
        expand("{sample}/bam/{sample}_sorted.bam.bai", sample = config["samples"]),
        expand("{sample}/bam/{sample}_sorted_deduped.bam", sample = config["samples"]),
        expand("{sample}/metrics/{sample}_deduped.txt", sample = config["samples"]),
        expand("{sample}/bam/{sample}_sorted_deduped_bqsr.bam", sample = config["samples"]),
        expand("{sample}/variants/raw/{sample}_raw.vcf", sample = config["samples"]),
        expand("{sample}/variants/filtered/{sample}_filtered.vcf", sample = config["samples"]),
        expand("{sample}/variants/annotations/{sample}_FUNCO.vcf", sample = config["samples"]),
        expand("{sample}/variants/annotations/{sample}_FUNCO.tsv", sample = config["samples"]),
        expand("{sample}/metrics/{sample}_align_metrics.txt", sample = config["samples"]),
        expand("{sample}/metrics/{sample}_insert_size_metrics.txt", sample = config["samples"]),
        expand("{sample}/metrics/{sample}_insert_size_histogram.pdf", sample = config["samples"])