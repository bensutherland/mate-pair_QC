#!/bin/bash
# Binning mate-pair data with NxTrim

# Global variables
TRIMMED_FOLDER="03_trimmed_data"
BINNED_FOLDER="04_binned_mps"
NXTRIM_PROGRAM="/home/bensuth/programs/NxTrim/nxtrim"

# Bin trimmed mate-pair data
ls -1 $TRIMMED_FOLDER/*paired.fastq.gz |
    perl -pe 's/R[12]\.paired\.fastq\.gz//' |
    sort -u |
    while read i
    do
	 echo $i
	$NXTRIM_PROGRAM \
		-1 "$i"R1.paired.fastq.gz \
		-2 "$i"R2.paired.fastq.gz \
		-O "$i" \
		--justmp
    done

# transfer trimmed files to $BINNED_FOLDER
mv $TRIMMED_FOLDER/*.mp.fastq.gz $BINNED_FOLDER
mv $TRIMMED_FOLDER/*.unknown.fastq.gz $BINNED_FOLDER
