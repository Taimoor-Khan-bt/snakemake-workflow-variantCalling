configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]

#------------------------------------------------------------------------------
# Rule for variant calling using GATK HaplotypeCaller -D
#------------------------------------------------------------------------------
rule variant_detection:
    input:
        bam = "{sample}/bam/{sample}_sorted_deduped_bqsr.bam",
        ref = config["reference_genome"]
    output:
        "{sample}/variants/raw/{sample}_raw.vcf"
    log:
        "{sample}/logs/gatk/{sample}-haplotypecaller.log"
    conda:
        "base"
    shell:
        "tools/gatk/gatk HaplotypeCaller -R {input.ref} -I {input.bam} -O {output}"