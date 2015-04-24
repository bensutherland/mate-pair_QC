mate-pair QC  
Version 0.1  
2015-04-24

### Disclaimer
This pipeline is made available **with no waranty of usefulness of any kind**.
It has been put together to improve the quality control of mate-pair library
insert sizes, and to improve the use of mate-pairs for scaffolding. It uses
valuable tools that have been developed by other groups (see Requires below)

# mate_pair-QC
Quality trim mate pairs, bin by conformation MP/PE/Unkn, align to reference then estimate insert size
Requires the following:  
`Trimmomatic`   http://www.usadellab.org/cms/?page=trimmomatic  
`NxTrim`        https://github.com/sequencing/NxTrim  
`bwa`           http://bio-bwa.sourceforge.net  
`samtools`      http://samtools.sourceforge.net  
`picard tools`  http://broadinstitute.github.io/picard/

## General comments
Raw *fastq.gz mate-pair data in 02_raw_data; run all jobs from the main directory.
Job files are specific to Katak at IBIS, but with some minor editing can be adapted for other servers.

# Trim for quality
Generates a 'paired' and 'single' fastq file for each mate-pair library  
requires `Trimmomatic`

Edit 01_scripts/01_trimming.sh by giving the path to `trimmomatic`  
Run locally:
```
01_scripts/01_trimming.sh
```

Run on Katak: 
```
qsub 01_scripts/jobs/01_trimming_job.sh
```

# Separate mate-pairs based on adapter presence and position
Bin quality trimmed paired mate-pairs for presence of adapter  
requires `NxTrim`  

Mate pairs can be in mate-pair conformation, paired-end conformation (i.e. shadow library) or unknown. `NxTrim` sorts each mate pair into these options based on presence of connecting adapter in forward or reverse read.

Edit 01_scripts/02_NxTrim_binning.sh by giving path to `nxtrim`

Locally:
```
01_scripts/02_NxTrim_binning.sh
```

On Katak:
```
qsub 01_scripts/jobs/02_NxTrim_binning_job.sh
```

Normally mate-pairs are in RF directionality, but NxTrim will revcomp and output as FR (ready for alignment)  
The output of this will give *.mp.fastq.gz in 04_binned_mps

# index reference with bwa
Note: only need to do this once  
requires `bwa`

Locally:
ensure reference is in fasta format (not compressed), and change REFERENCE to the path to your reference you want to align against
```
bwa index REFERENCE
```

On Katak:
```
qsub 01_scripts/jobs/03a_indexRef_job.sh
```

# align mate-pairs against reference

requires `bwa` and `samtools`

Edit 01_scripts/03b_BWAaln.sh by giving path and names to each sample and RG indexes (e.g. replace short identifier (bolded for clarity)) for each RG at RG[1]='@RG\tID:**lib208**\tSM:**lib208**\tPL:Illumina'

Locally:
```
01_scripts/03b_BWAaln.sh
```

On Katak: 
```
qsub 01_scripts/jobs/03b_BWAaln_job.sh
```

# evaluate your mate-pair libraries
### estimate number of mapped reads using:
```
samtools flagstat <your.bam>
```
### estimate insert size
requires `picard tools`
locally:

```
./01_scripts/04_estInsertSizes.sh
```

On Katak:
```
qsub 01_scripts/jobs/04_estInsertSizes_job.sh
```

Enjoy! Hopefully your insert sizes are as you expect.
