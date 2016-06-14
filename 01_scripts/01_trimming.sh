#!/bin/bash
# Cleaning and trimming data with trimmomatic

# Load Trimmomatic
module load trimmomatic/0.33

# Global variables
RAW_FOLDER="02_raw_data"
TRIMMED_FOLDER="03_trimmed_data"
TRIMMOMATIC_PROGRAM="trimmomatic-0.33.jar"

# User-specific variables
# Set vector file depending on your input data files
VECTORS="00_archive/illumina_nextera_mp_non-junction_adapters.fasta"

# If not working in a SLURM environment, set trimmomatic path 
# TRIMMOMATIC_PROGRAM="/prg/trinityrnaseq/trinityrnaseq_r20140717/trinity-plugins/Trimmomatic-0.32/trimmomatic.jar"

# Filtering and trimming data with trimmomatic
ls -1 $RAW_FOLDER/*.fastq.gz |
    perl -pe 's/R[12]\.fastq\.gz//' |
    sort -u |
    while read i
    do
        echo $i
        $TRIMMOMATIC_PROGRAM PE \
            -threads 10 \
            -phred33 \
            "$i"R1.fastq.gz "$i"R2.fastq.gz \
            "$i"R1.paired.fastq.gz \
            "$i"R1.single.fastq.gz \
            "$i"R2.paired.fastq.gz \
            "$i"R2.single.fastq.gz \
            ILLUMINACLIP:$VECTORS:2:30:10 \
            SLIDINGWINDOW:20:10 \
            LEADING:10 \
            TRAILING:10 \
            MINLEN:80
    done

# Transfer trimmed files to $TRIMMED_FOLDER folder
mv $RAW_FOLDER/*single* $TRIMMED_FOLDER
mv $RAW_FOLDER/*paired* $TRIMMED_FOLDER
