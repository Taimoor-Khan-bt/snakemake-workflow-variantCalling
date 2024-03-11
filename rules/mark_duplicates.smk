configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]

#------------------------------------------------------------------------------
# Rule for marking duplicates -D
#------------------------------------------------------------------------------
rule dedup_bam:
    input:
        "{sample}/bam/{sample}_sorted.bam"
    output:
        deduped_bam = "{sample}/bam/{sample}_sorted_deduped.bam",
        metrics = "{sample}/metrics/{sample}_deduped.txt"
    log:
        "{sample}/logs/picard/{sample}-dedup.log"
    conda:
        "bioinfo"
    shell:
        "picard MarkDuplicates I={input} O={output.deduped_bam} M={output.metrics}"
