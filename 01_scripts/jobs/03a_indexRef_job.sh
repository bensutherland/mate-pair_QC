#!/bin/bash
# used to index reference
REFERENCE=/project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta.gz > /project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta

#unzip fasta
gunzip -c /project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta.gz > /project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta

#Create a shell variable to store the location of our reference transcriptome
REFERENCE=/project/lbernatchez/drobo/users/bensuth/00_resources/Ssa_ASM_3.6.fasta

#Index reference transcriptome
# bwa index $REFERENCE

#Map the reads
for i in 1 2 3
do
    sample=${SAMPLES[${i}]}
    #Map the reads
    bwa mem -p -t 10 -R ${RG[${i}]} $REFERENCE ${sample} > ${sample}.sam
    samtools view -Sb ${sample}.sam > ${sample}.unsorted.bam  #-S = input sam -b = output bam
    samtools sort ${sample}.unsorted.bam ${sample}
    samtools index ${sample}.bam
    # htseq-count --format=bam --stranded=no --type=CDS --order=pos --idattr=Name ${sample}.bam Trinity_all_X.gff3 > ${sample}_htseq_counts.txt
done

mv ./04_binned_mps/*.bam ./05_aligned_to_ref/
mv ./04_binned_mps/*.sam ./05_aligned_to_ref/
