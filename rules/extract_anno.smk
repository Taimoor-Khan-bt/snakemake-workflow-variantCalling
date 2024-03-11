configfile: "config.yaml"
#------------------------------------------------------------------------------
# Define functions here
#------------------------------------------------------------------------------
def get_bwa_map_fastq_inputs(wildcards):
    return config["samples"][wildcards.sample]

#------------------------------------------------------------------------------
# Define a rule for extracting annotations from the final vcf files
#------------------------------------------------------------------------------
rule extract_annotations:
    input:
        vcf="{sample}/variants/annotations/{sample}_FUNCO.vcf",
        tsv="{sample}/variants/annotations/{sample}_tempFUNCO.tsv"
    output:
        "{sample}/variants/annotations/{sample}_FUNCO.tsv"
    shell:
        """
        # Extract the headers (Funcotation fields) from the VCF files
        cat {input.vcf} | grep "Funcotation fields are:" | sed 's/|/\\t/g' > {output}
        
        # Extract the annotation (funcotation) from the table and append it to the headers file
        cat {input.tsv} | cut -f 15 | sed 's/|/\\t/g' >> {output}
        """
