configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]



rule variant_filteration:
    input:
        raw_vcf = "{sample}/variants/raw/{sample}_raw.vcf",
        ref = config["reference_genome"]
    output:
        filter = temp("{sample}/variants/{sample}_scr1.vcf"),
        final1 = temp("{sample}/variants/{sample}_scr2.vcf"),
        final = "{sample}/variants/filtered/{sample}_filtered.vcf"
    log:
        "{sample}/logs/gatk/{sample}-variantfilteration.log"
    conda:
        "base"
    shell:
        """
        tools/gatk/gatk VariantFiltration -R {input.ref} -V {input.raw_vcf} -O {output.filter} \
        --filter-name "QD_filter" --filter "QD < 2.0" \
        --filter-name "FS_filter" --filter "FS > 60.0" \
        --filter-name "MQ_filter" --filter "MQ < 40.0" \
        --filter-name "SOR_filter" --filter "SOR > 4.0" \
        --filter-name "MQRankSum_filter" --filter "MQRankSum < -12.5" \
        --filter-name "ReadPosRankSum_filter" --filter "ReadPosRankSum < -8.0" \
        --genotype-filter-expression "DP < 10" --genotype-filter-name "DP_filter" \
        --genotype-filter-expression "GQ < 10" --genotype-filter-name "GQ_filter" \
        && tools/gatk/gatk SelectVariants --exclude-filtered -V {output.filter} -O {output.final1} \
        && cat {output.final1} | \
        grep -v -E "DP_filter|GQ_filter" > {output.final}
        """