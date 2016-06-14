#!/bin/bash
# Estimate the insert size in the mate-pair library using the Picard Tool CollectInsertSizeMetrics

# Set variables
ALIGNED_FOLDER="05_aligned_to_ref"
PICARD="programs/picard-tools-2.4.1/picard.jar"

# Estimate insert sizes
ls -1 $ALIGNED_FOLDER/*sorted.bam |
    sort -u |
    while read i
    do
        echo "Estimating insert sizes for $i"
        $PICARD CollectInsertSizeMetrics \
		HISTOGRAM_FILE="$i"_insert_size.pdf \
		INPUT="$i" \
		OUTPUT="$i".txt \
        INCLUDE_DUPLICATES=false # reads marked as duplicate will not be included in the histogram
    done
