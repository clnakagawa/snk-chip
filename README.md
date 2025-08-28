# ChIP-seq Workflow Using Snakemake

## Usage

This workflow was used to process public ChIP-seq data from GEO. The purpose was to validate existing data using the same standards used for CFF lab data. A samplesheet is used to specify sample labels and paths to sample and optional control fastq file(s). 

## Notes

The workflow was constrained by a few factors including issues with MACS installation on the Azure server used for data processing. As such, there are a few points that may be optimized in the future, such as using a conda-installed MACS installation rather than hard-coding a working installation in the params of certain rules.

## References

> Köster, J., Mölder, F., Jablonski, K. P., Letcher, B., Hall, M. B., Tomkins-Tinch, C. H., Sochat, V., Forster, J., Lee, S., Twardziok, S. O., Kanitz, A., Wilm, A., Holtgrewe, M., Rahmann, S., & Nahnsen, S. _Sustainable data analysis with Snakemake_. F1000Research, 10:33, 10, 33, **2021**. https://doi.org/10.12688/f1000research.29032.2.
