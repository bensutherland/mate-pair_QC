#!/bin/bash
# Trimming mate-pair data with NxTrim

# Global variables
TRIMMED_FOLDER="03_trimmed_data"
BINNED_FOLDER="04_binned_mps"
NXTRIM_PROGRAM="/project/lbernatchez/drobo/users/bensuth/programs/NxTrim/nxtrim"


# binning mate-pair MI.Seq data within the trimmed folder
ls -1 $TRIMMED_FOLDER/*.fastq.gz | \
    perl -pe 's/R[12]\.paired\.fastq\.gz//' | \
    grep -vE "paired|single" | \
    sort -u | \
    while read i
    do
       echo $i
	$NXTRIM_PROGRAM \
		-1 "$i"R1.paired.fastq.gz \
		-2 "$i"R2.paired.fastq.gz \
		-O $BINNED_FOLDER/"$i" \
		--justmp
    done
