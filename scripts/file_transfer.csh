#!/bin/sh
#
#SBATCH --job-name=filetransfer
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=shared

echo "Copy all of the neede files to the data folder
cp -r /data/sprehei1@jhu.edu/Raw_data_groups/sprehei1_123456 .
cp -r /data/sprehei1@jhu.edu/Raw_data_groups/sprehei1_7891011 .

echo "Complete"

