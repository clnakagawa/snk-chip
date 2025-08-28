# rules for fastqc, alignment, trimming
rule fastqc:
    input:
        lambda wildcards: sample_to_fq[wildcards.sample]
    output:
        dir = directory(f"{OUTDIR}/QC/{{sample}}")
    conda:
        "../envs/fastqc.yaml"
    shell:
        """
        mkdir -p {output.dir}
        fastqc {input} --outdir {output.dir}
        """

rule trim_fq:
    input:
        fq = lambda wildcards: sample_to_fq[wildcards.sample],
        adapters = "/opt/software/Trimmomatic/trimmomatic-0.39/adapters/TruSeq3-SE.fa"
    output:
        trimmed = f"{OUTDIR}/trimmed/{{sample}}.trimmed.fastq.gz",
        log = f"{OUTDIR}/trimmed/logs/{{sample}}.log.txt"
    conda:
        "../envs/trimmomatic.yaml"
    shell:
        """
        if [ ! -d {OUTDIR}/trimmed/logs ]; then
            mkdir -p {OUTDIR}/trimmed/logs
        fi

        trimmomatic SE \
            -phred33 \
            -trimlog {output.log} \
            -threads 8 \
            {input.fq} \
            {output.trimmed} \
            ILLUMINACLIP:{input.adapters}:2:30:10:8:TRUE \
            LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
        """