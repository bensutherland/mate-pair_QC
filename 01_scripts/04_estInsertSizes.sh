#!/bin/bash

ALIGNMENT_FOLDER="./05_aligned_to_ref"
INSERT_PROGRAM="path/to/insert/program/CollectInsertSizeMetrics.jar"


# Filtering and trimming data with trimmomatic
ls -1 $RAW_FOLDER/*.gz.bam | \
    # perl -pe 's/R[12]\.fastq\.gz//' | \
    sort -u | \
    while read i
    do
        echo $i
        java -Xmx2G -jar $INSERT_PROGRAM \
		HISTOGRAM_FILE="i"_insert_size_chart.pdf \
		INPUT="i" \
		OUTPUT="i".txt
done 
