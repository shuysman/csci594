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
#SBATCH --cpus-per-task=130              # number of cores to allocate
#SBATCH --mem=256G                     # 2000 MB of Memory allocated; set --mem with care
#SBATCH --time=0-6:00:00                 # Maximum job run time
#SBATCH --mail-user=shuysman@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=assignment5-%j.out
#SBATCH --error=assignment5-%j.err


start=`date +%s`
hostname -s

THREADS=128

echo $THREADS

NCDIR=$HOME/data/MACA/gye/forecasts/daily
OUTDIR=$HOME/out

module load Mamba
source $HOME/.bashrc
mamba activate cdo

##cdo -P 1 ensmean -selyear,2050/2059 $NCDIR/tmmx_{bcc-csm1-1,BNU-ESM,CanESM2,CNRM-CM5,CSIRO-Mk3-6-0,GFDL-ESM2G,GFDL-ESM2M,HadGEM2-CC365,HadGEM2-ES365,inmcm4,IPSL-CM5A-LR,IPSL-CM5A-MR,IPSL-CM5B-LR,MIROC5,MIROC-ESM-CHEM,MIROC-ESM,MRI-CGCM3}
cdo -P $THREADS ensmean -selyear,2050/2059 $NCDIR/tmmx_{bcc-csm1-1,BNU-ESM,CanESM2,CNRM-CM5}_rcp45_2006-2099_daily_gye.nc $OUTDIR/ensmean-$THREADS.nc

end=`date +%s`
runtime=$((end-start))

echo $runtime
