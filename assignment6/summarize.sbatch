#!/bin/bash
#SBATCH --partition priority
#SBATCH --account priority-csci494
#SBATCH --cpus-per-task 1
#SBATCH --mem 1000
#SBATCH --time 0-00:40:00
#SBATCH --job-name summary
#SBATCH --output summary-%j.out
#SBATCH --error summary-%j.err
#SBATCH --dependency=afterany:<jobid>
#SBATCH --mail-type END

date
hostname -s

module load Mamba
source $HOME/.bashrc
mamba activate r-test

Rscript swe_ensemble.R 

date
