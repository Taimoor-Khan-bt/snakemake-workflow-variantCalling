configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]

#------------------------------------------------------------------------------
# Rule for collecting alignment and insert size metrices -D
#------------------------------------------------------------------------------
rule align_metric:
    input:
        bqsr_bam = "{sample}/bam/{sample}_sorted_deduped_bqsr.bam",
        ref = config["reference_genome"]
    output:
        alignment_metrics = "{sample}/metrics/{sample}_align_metrics.txt"
    log:
        "{sample}/logs/gatk/{sample}-align-metric.log"
    conda:
        "base"
    shell:
        "tools/gatk/gatk CollectAlignmentSummaryMetrics R={input.ref} I={input.bqsr_bam} O={output.alignment_metrics}"
        

rule insert_size_metric:
    input:
        bqsr_bam = "{sample}/bam/{sample}_sorted_deduped_bqsr.bam"
    output:
        insert_size_metrics = "{sample}/metrics/{sample}_insert_size_metrics.txt",
        insert_size_histogram = "{sample}/metrics/{sample}_insert_size_histogram.pdf"
    log:
        "{sample}/logs/gatk/{sample}-insert-size-metric.log"
    conda:
        "base"
    shell:
        "tools/gatk/gatk CollectInsertSizeMetrics INPUT={input.bqsr_bam} OUTPUT={output.insert_size_metrics} HISTOGRAM_FILE={output.insert_size_histogram}"