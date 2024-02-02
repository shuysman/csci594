#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-csci494        #specify the account to use
#SBATCH --job-name=assignment3            # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
#SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --cpus-per-task=2              # number of cores to allocate
#SBATCH --mem=8G                     # 2000 MB of Memory allocated; set --mem with care
#SBATCH --time=0-00:10:00                 # Maximum job run time
##SBATCH --array=1-3                  # Number of jobs in array
#SBATCH --output=assignment3-%j.out
#SBATCH --error=assignment3-%j.err

## Run 'man sbatch' for more information on the options above.

date                            # print out the date
hostname -s                     # print a message from the compute node
module load Mamba
source $HOME/.bashrc
mamba activate assignment3
python assignment3.py
date                            # print the date again

