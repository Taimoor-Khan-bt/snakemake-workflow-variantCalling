

rule all:
    input:
        "analysis/bam/Ali_Bahlas_sorted.bam"
        "analysis/bam/Ali_Bahlas_sorted.bam.bai"
        "analysis/bam/Ali_Bahlas_sorted_deduped.bam"
        "analysis/metrics/Ali_Bahlas_deduped.txt"
        "analysis/bam/Ali_Bahlas_sorted_deduped_bqsr.bam"
        "analysis/metrics/Ali_Bahlas_align_metrics.txt"
        "analysis/metrics/Ali_Bahlas_insert_size_metrics.txt"
        "analysis/metrics/Ali_Bahlas_insert_size_histogram.pdf"
        "analysis/variants/Ali_Bahlas_raw.vcf"
        "analysis/variants/Ali_Bahlas_filtered.vcf"
        "analysis/variants/Ali_Bahlas_final.vcf"
        "analysis/varinats/Ali_Bahlas_funcotated.vcf"
        "analysis/variants/Ali_Bahlas_funcotated.tsv"
        "analysis/variants/Ali_Bahlas_funcotated.txt"
        "analysis/annotations/Ali_Bahlas_ANNO.tsv"