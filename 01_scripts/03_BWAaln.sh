#!/bin/bash
# use bwa mem to map trimmed reads to reference library

#Create an array to hold the names of all our samples
#Later, we can then cycle through each sample using a simple foor loop
SAMPLES[1]=./04_binned_mps/MI.M00833_0208.001.Index_5.Brook_char_extraction_2_.mp.fastq.gz
SAMPLES[2]=./04_binned_mps/MI.M00833_0209.001.Index_6.Brook_char_extraction_1_.mp.fastq.gz
SAMPLES[3]=./04_binned_mps/MI.M00833_0210.001.Index_7.Brook_char_extraction_2_.mp.fastq.gz

RG[1]='@RG\tID:lib208\tSM:lib208\tPL:Illumina'
RG[2]='@RG\tID:lib209\tSM:lib209\tPL:Illumina'
RG[3]='@RG\tID:lib210\tSM:lib210\tPL:Illumina'

# unzip fasta
gunzip -c /project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta.gz > /project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta

#Create a shell variable to store the location of our reference transcriptome
REFERENCE=/project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta

#Index reference transcriptome
bwa index $REFERENCE

#Map the reads
for i in 1 2 3
do
    sample=${SAMPLES[${i}]}
    #Map the reads
    bwa mem -t 10 -R ${RG[${i}]} $REFERENCE ${sample} > ${sample}.sam
    samtools view -Sb ${sample}.sam > ${sample}.unsorted.bam  #-S = input sam -b = output bam
    samtools sort ${sample}.unsorted.bam ${sample}
    samtools index ${sample}.bam
    # htseq-count --format=bam --stranded=no --type=CDS --order=pos --idattr=Name ${sample}.bam Trinity_all_X.gff3 > ${sample}_htseq_counts.txt
done

mv ./04_binned_mps/*.bam ./05_aligned_to_ref/
mv ./04_binned_mps/*.sam ./05_aligned_to_ref/
