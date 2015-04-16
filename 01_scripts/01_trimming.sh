#!/bin/bash
# Cleaning and trimming data with trimmomatic

# Global variables
RAW_FOLDER="02_raw_data"
TRIMMED_FOLDER="03_trimmed"
VECTORS="./00_archive/univec_trimmomatic.fasta"
TRIMMOMATIC_PROGRAM="/prg/trinityrnaseq/trinityrnaseq_r20140717/trinity-plugins/Trimmomatic-0.32/trimmomatic.jar"

# Filtering and trimming data with trimmomatic
ls -1 $RAW_FOLDER/*.fastq.gz | \
    perl -pe 's/R[12]\.fastq\.gz//' | \
    grep -vE "paired|single" | \
    sort -u | \
    while read i
    do
        echo $i
        java -Xmx160G -jar $TRIMMOMATIC_PROGRAM PE \
            -threads 20 \
            -phred33 \
            "$i"R1.fastq.gz \
            "$i"R2.fastq.gz \
            "$i"R1.paired.fastq.gz \
            "$i"R1.single.fastq.gz \
            "$i"R2.paired.fastq.gz \
            "$i"R2.single.fastq.gz \
            ILLUMINACLIP:$VECTORS:2:30:10 \
            SLIDINGWINDOW:20:30 \
            LEADING:20 \
            TRAILING:20 \
            MINLEN:80
    done

# Transfer trimmed files to $TRIMMED_FOLDER folder
mv $RAW_FOLDER/*single* $TRIMMED_FOLDER
mv $RAW_FOLDER/*paired* $TRIMMED_FOLDER

# Indicate that the trimming is done
touch finished.01_trimming
