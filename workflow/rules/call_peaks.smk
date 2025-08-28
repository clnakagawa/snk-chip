# helper function to generate input for call_peaks

def get_macs_input(wildcards):
    inputs = {'sample' : f"{OUTDIR}/alignments/{wildcards.sample}.fltr.bam"}
    control = sample_to_ctrl.get(wildcards.sample)
    if control and not pd.isnull(control):
        inputs['control'] = f"{OUTDIR}/alignments/{control}.fltr.bam"
    return(inputs)

rule call_peaks:
    input: 
        unpack(get_macs_input)
    output:
        directory(f"{OUTDIR}/peaks/{{sample}}")
    params:
        macsPath='/opt/data/cnakaChIP/tools/bin/macs2' # conda installed macs throws errors, need to specify working macs installation
    run:
        shell("mkdir -p {output}")
        if "control" in input:
            shell("{params.macsPath} callpeak -t {input.sample} -c {input.control} -f BAM -g hs --outdir {output} -n {wildcards.sample} --call-summits")
        else:
            shell("{params.macsPath} callpeak -t {input.sample} -f BAM -g hs --outdir {output} -n {wildcards.sample} --call-summits")