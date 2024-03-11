configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]

#------------------------------------------------------------------------------
# Rule for base quality recalibration -D
#------------------------------------------------------------------------------
rule bqsr_bam:
    input:
        bam = "{sample}/bam/{sample}_sorted_deduped.bam",
        ref = config["reference_genome"],
        known_sites = config["known_sites_vcf"]
    output:
        temp("{sample}/recal/{sample}_recal.table")
    log:
        "{sample}/logs/gatk/{sample}-bsqr.log"
    conda:
        "base"
    shell:
        "tools/gatk/gatk BaseRecalibrator -I {input.bam} -R {input.ref} --known-sites {input.known_sites} -O {output}"

#------------------------------------------------------------------------------
# Rule for applying base quality recalibration -D
#------------------------------------------------------------------------------
rule apply_bqsr_bam:
    input:
        bam = "{sample}/bam/{sample}_sorted_deduped.bam",
        ref = config["reference_genome"],
        recal = "{sample}/recal/{sample}_recal.table"
    output:
        "{sample}/bam/{sample}_sorted_deduped_bqsr.bam"
    log:
        "{sample}/logs/gatk/{sample}-abqsr.log"
    conda:
        "base"
    shell:
        "tools/gatk/gatk ApplyBQSR -I {input.bam} -R {input.ref} --bqsr-recal-file {input.recal} -O {output}"
