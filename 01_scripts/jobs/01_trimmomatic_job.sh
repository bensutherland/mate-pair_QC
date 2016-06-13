#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=bensutherland7@gmail.com
#SBATCH -J trimmomatic 
#SBATCH --cpus-per-task=10
#SBATCH --time=60:00:00
#SBATCH --mem=20000

time ./01_scripts/01_trimming.sh
