configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]


#---------------------------------------------------------------------------------
# RULE: 1) MAP-SORT-INDEX-BAM | Input: .fastq/fastq.gz | Output: .bam & .bam.bai
#---------------------------------------------------------------------------------
rule bwa_map:
    input: 
        config["reference_genome"],
        R1 = "data/samples/{sample}/{sample}_1.fastq",
        R2 = "data/samples/{sample}/{sample}_2.fastq"
    output:
        temp("{sample}/sam/{sample}.sam")
    threads:
        4
    log:
        "{sample}/logs/bwa/bwa_map.log"
    conda:
        "bioinfo"
    shell:
        "bwa mem -M {input} > {output}"

rule picard_add_read_groups:
    input:
        "{sample}/sam/{sample}.sam"
    output:
        temp("{sample}/sam/{sample}_rg.sam")
    params:
        rg_id = "MG00HS09",
        rg_lb = "SureSelect_v4",
        rg_pl = "ILLUMINA",
        rg_pu = "NULL",
        rg_sm = "{sample}"
    conda:
        "bioinfo"
    shell:
        """
        picard AddOrReplaceReadGroups \
            I={input} \
            O={output} \
            RGID={params.rg_id} \
            RGLB={params.rg_lb} \
            RGPL={params.rg_pl} \
            RGPU={params.rg_pu} \
            RGSM={params.rg_sm}
        """

rule samtools_sam_to_bam:
    input:
        "{sample}/sam/{sample}_rg.sam"
    output:
        temp("{sample}/bam/{sample}_raw.bam")
    conda:
        "bioinfo"
    shell:
        "samtools view -Sb {input} > {output}"

rule samtools_sort:
    input:
        "{sample}/bam/{sample}_raw.bam"
    output:
        "{sample}/bam/{sample}_sorted.bam"
    conda:
        "bioinfo"
    shell:
        "samtools sort {input} -o {output}"

rule samtools_index:
    input:
        "{sample}/bam/{sample}_sorted.bam"
    output:
        "{sample}/bam/{sample}_sorted.bam.bai"
    conda:
        "bioinfo"
    shell:
        "samtools index {input} > {output}"
