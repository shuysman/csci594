#!/bin/bash
##
## example-array.slurm.sh: submit an array of jobs with a varying parameter
##
## Lines starting with #SBATCH are read by Slurm. Lines starting with ## are comments.
## All other lines are read by the shell.
##
#SBATCH --account=priority-briansmithers        #specify the account to use
#SBATCH --job-name=assignment5            # job name
#SBATCH --partition=priority              # queue partition to run the job in
#SBATCH --nodes=1                       # number of nodes to allocate
##SBATCH --ntasks-per-node=1             # number of descrete tasks - keep at one except for MPI
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128              # number of cores to allocate
#SBATCH --mem=256G                     # 2000 MB of Memory allocated; set --mem with care
#SBATCH --time=0-6:00:00                 # Maximum job run time
#SBATCH --mail-user=shuysman@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=assignment5-%j.out
#SBATCH --error=assignment5-%j.err


start=`date +%s`
date
hostname -s

THREADS=128

echo $THREADS

NCDIR=data
OUTDIR=$HOME/out

module load Mamba
source $HOME/.bashrc
mamba activate cdo


### Prepare subsets of data because running on whole 2006-2099 dataset takes forever
# for model in bcc-csm1-1 BNU-ESM;
# do
# cdo selyear,2050/2059 $NCDIR/tmmx_${model}_rcp45_2006-2099_daily_gye.nc $OUTDIR/${model}_tmmx_2050-2059.nc
# done


## cdo -P $THREADS ensmean $NCDIR/tmmx_{bcc-csm1-1,BNU-ESM,CanESM2,CNRM-CM5,CSIRO-Mk3-6-0,GFDL-ESM2G,GFDL-ESM2M,HadGEM2-CC365,HadGEM2-ES365,inmcm4,IPSL-CM5A-LR,IPSL-CM5A-MR,IPSL-CM5B-LR,MIROC5,MIROC-ESM-CHEM,MIROC-ESM,MRI-CGCM3}_rcp45_2006-2099_daily_gye.nc $OUTDIR/ensmean-$THREADS.nc
cdo -P $THREADS ensmean $NCDIR/{bcc-csm1-1,BNU-ESM}_tmmx_2050-2059.nc $OUTDIR/ensmean-$THREADS.nc

end=`date +%s`
runtime=$((end-start))

echo $runtime
date
