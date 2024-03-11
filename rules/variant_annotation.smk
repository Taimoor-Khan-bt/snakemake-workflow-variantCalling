configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]


rule variant_annotation:
    input:
        vcf = "{sample}/variants/filtered/{sample}_filtered.vcf",
        ref = config["reference_genome"],
        data_source = config["data_sources"]
    output:
        vcf = "{sample}/variants/annotations/{sample}_FUNCO.vcf",
        tsv = temp("{sample}/variants/annotations/{sample}_tempFUNCO.tsv")
    log:
        "{sample}/logs/gatk/{sample}-funcotator.log"
    conda:
        "base"
    shell:
        """
        tools/gatk/gatk Funcotator \
        -V {input.vcf} \
        -R {input.ref} \
        --ref-version hg19 \
        --data-sources-path {input.data_source} \
        -O {output.vcf} \
        --output-file-format VCF \
        && tools/gatk/gatk VariantsToTable -V {output.vcf} -O {output.tsv}
        """
