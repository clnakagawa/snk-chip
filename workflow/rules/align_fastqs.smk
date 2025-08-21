rule align_fq:
    input:
        f"{OUTDIR}/trimmed/{{sample}}.trimmed.fastq.gz"
    output:
        f"{OUTDIR}/alignments/{{sample}}.bam"
    conda:
        "../envs/align.yaml"
    shell:
        """
        if [ ! -d {OUTDIR}/alignments ]; then
            mkdir -p {OUTDIR}/alignments
        fi
        
        bwa mem -t 8 {HGREF} {input} | samtools view -b - > {output}
        """

rule sort_idx_bam:
    input:
        f"{OUTDIR}/alignments/{{sample}}.bam"
    output:
        sortedBam = f"{OUTDIR}/alignments/{{sample}}.sort.bam",
        idx = f"{OUTDIR}/alignments/{{sample}}.bai"
    conda:
        "../envs/align.yaml"
    shell:
        """
        samtools sort -l 9 -o {output.sortedBam} {input}
        samtools index -o {output.idx} {output.sortedBam}

        rm {input}
        """

rule mark_bam:
    input:
        f"{OUTDIR}/alignments/{{sample}}.sort.bam"
    output:
        markedBam = f"{OUTDIR}/alignments/{{sample}}.mark.bam",
        log = f"{OUTDIR}/alignments/logs/{{sample}}.dup.metrics.txt"
    conda:
        "../envs/picard.yaml"
    shell:
        """
        if [ ! -d {OUTDIR}/alignments/logs ]; then
            mkdir -p {OUTDIR}/alignments/logs
        fi

        picard -Xmx12g MarkDuplicates \
            I={input} \
            O={output.markedBam} \
            M={output.log} \
            REMOVE_DUPLICATES=false \
            VALIDATION_STRINGENCY=LENIENT
        """