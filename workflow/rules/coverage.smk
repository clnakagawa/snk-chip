rule make_tdf:
    input:
        bam = f"{OUTDIR}/alignments/{{sample}}.fltr.bam"
    output:
        f"{OUTDIR}/coverage/{{sample}}.tdf"
    conda:
        "../envs/igvtools.yaml"
    shell:
        """
        if [ ! -d {OUTDIR}/alignments ]; 
        then
            mkdir -p {OUTDIR}/alignments
        fi

        igvtools count -w 5 --minMapQuality 20 {input.bam} {output} {HGREF}
        """
rule make_bg:
    input:
        f"{OUTDIR}/coverage/{{sample}}.tdf"
    output:
        f"{OUTDIR}/coverage/{{sample}}.bedgraph"
    conda:
        "../envs/igvtools.yaml"
    shell:
        "igvtools tdftobedgraph {input} {output}"

rule sort_bg:
    input:
        f"{OUTDIR}/coverage/{{sample}}.bedgraph"
    output:
        f"{OUTDIR}/coverage/sorted.{{sample}}.bedgraph"
    shell:
        """
        sort -k1,1 -k2,2n {input} > {output}
        rm {input}
        """

rule make_chr_sizes:
    output:
        "/drives/hd/cnakagawa/snk-chip/refs/chrom.sizes.tsv"
    conda:
        "../envs/align.yaml"
    shell:
        """
        samtools faidx {HGREF}
        cut -f 1,2 {HGREF}.fai > {output}
        """

rule make_bw:
    input:
        bg = f"{OUTDIR}/coverage/sorted.{{sample}}.bedgraph",
        chrSizes = "/drives/hd/cnakagawa/snk-chip/refs/chrom.sizes.tsv"
    output:
        bw = f"{OUTDIR}/coverage/{{sample}}.bw"
    conda:
        "../envs/bg2bw.yaml"
    shell:
        """
        bedGraphToBigWig {input.bg} {input.chrSizes} {output} 
        rm {input.bg}
        """