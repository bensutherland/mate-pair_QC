#!/bin/bash
#$ -N trim
#$ -M email.address
#$ -m beas
#$ -pe smp 10
#$ -l h_vmem=100G
#$ -l h_rt=14:00:00
#$ -cwd
#$ -S /bin/bash

time ./01_scripts/01_trimming.sh

