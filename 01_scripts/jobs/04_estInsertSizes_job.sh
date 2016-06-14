#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=bensutherland7@gmail.com
#SBATCH -J estInsertSizes 
#SBATCH --cpus-per-task=1
#SBATCH --time=60:00:00
#SBATCH --mem=20000

time ./01_scripts/04_estInsertSizes.sh 

