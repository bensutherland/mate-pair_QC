#!/bin/bash
# Map binned reads to reference genome using bwa mem

# Load modules
module load bwa/0.7.13
module load samtools/1.3

# Point to the reference
REFERENCE="~/00_resources/GCA_000233375.4_ICSASG_v2_genomic.fna.gz"

# Set environment variables
BINNED_FOLDER="04_binned_mps"

# Map the binned reads
ls -1 $BINNED_FOLDER/*mp.fastq.gz
    perl -pe 's/\.fastq\.gz//' |
    sort -u |
    while read i
    do
        echo "Mapping "$i".fastq.gz"
        bwa mem -p -t 10 $REFERENCE "$i".fastq.gz > "$i".sam # -p flag indicates the data is interleaved paired data
        samtools view -Sb "$i".sam > "$i".unsorted.bam  #-S = input sam -b = output bam
        samtools sort "$i".unsorted.bam "$i".sorted
        samtools index "$i".sorted.bam
    done

# Move files
mv ./04_binned_mps/*.bam ./05_aligned_to_ref/
mv ./04_binned_mps/*.sam ./05_aligned_to_ref/
