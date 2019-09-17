#!/bin/sh
#
##SBATCH --job-name=QIIME2_single
#SBATCH --time=72:00:00
#SBATCH --ntasks=5
#SBATCH --cpus-per-task=1
#SBATCH --partition=lrgmem
#SBATCH --mem-per-cpu=20G

module load qiime2/2018.8

#cp single_config.txt to this folder
#edit variables according to analysis
#save them and this will use those in this analysis
source ./paired_config.txt

#echo the time for each
echo "Starting qiime2 analysis"
date
#import the demultiplexed data
echo "Starting import"
date
qiime tools import --type EMPPairedEndSequences --input-path $DATA --output-path ${PREFIX}.qza

#demultiplexing data
echo "Starting demux"
date
qiime demux emp-paired --i-seqs ${PREFIX}.qza --m-barcodes-file $METADATA --m-barcodes-column BarcodeSequence --p-rev-comp-mapping-barcodes --o-per-sample-sequences ${PREFIX}_demux.qza
qiime demux summarize --i-data ${PREFIX}_demux.qza --o-visualization ${PREFIX}_demux.qzv
#use dada2 to remove sequencing errors
echo "Starting dada2"

date

qiime dada2 denoise-paired --i-demultiplexed-seqs ${PREFIX}_demux.qza --p-trim-left-f 23 --p-trim-left-r 23 --p-trunc-len-f 200 --p-trunc-len-r 200 --o-representative-sequences ${PREFIX}_reps.qza --o-table ${PREFIX}_dada2.qza --o-denoising-stats ${PREFIX}_stats-dada2.qza --p-n-threads 0 --p-min-fold-parent-over-abundance 10

echo "End of script"
date
