#!/bin/bash
#SBATCH --partition priority
#SBATCH --account priority-briansmithers
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 64G
#SBATCH --time 0-00:40:00
#SBATCH --job-name assignment6
#SBATCH --array=1-13
#SBATCH --output assignment6-%j.out
#SBATCH --error assignment6-%j.err

date
hostname -s

scenario=rcp45
start_year=2050
end_year=2059

module load Mamba
source $HOME/.bashrc
mamba activate r-test

Rscript avg_swe.R $SLURM_ARRAY_TASK_ID $scenario $start_year $end_year

date
