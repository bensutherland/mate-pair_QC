#!/bin/bash
#$ -N estInsert
#$ -M bensutherland7@gmail.com 
#$ -m beas
#$ -pe smp 3
#$ -l h_vmem=20G
#$ -l h_rt=6:00:00
#$ -cwd
#$ -S /bin/bash

time ./01_scripts/04_estInsertSizes.sh 

