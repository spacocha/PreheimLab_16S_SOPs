#!/bin/sh
#
#SBATCH --job-name=QIIME2_single
#SBATCH --time=72:00:00

PREFIX=emp-single-end-sequences
#describe path to the appropriate data folder
#folder should contain only two files with the names
#barcodes.fastq.gz
#sequences.fastq.gz
#This should be for one seuqencing run
#also must be zipped
#this should be linked to the data in the ../data/run_name folder
#use the following: ln -s ../data/run_name/forward.fastq.gz sequences.fastq.gz
DATA=emp-single-end-sequences
#Specify path to the mapping file
#This must be checked by the KEIMEI in google sheets and be approved QIIME2 format
#This should be in the current working directory
METADATA=sample-metadata.tsv

module load qiime2/2018.8

#Make this if it doesn't already exist
#mkdir ~/scratch/tmp
export TMPDIR='~/scratch/tmp'
#echo the time for each
echo "Starting qiime2 analysis"
date

#import the demultiplexed data
echo "Starting import"
date
qiime tools import --type EMPSingleEndSequences --input-path $DATA --output-path ${PREFIX}.qza

#demultiplexing data
echo "Starting demux"
date
qiime demux emp-single --i-seqs ${PREFIX}.qza --m-barcodes-file $METADATA --m-barcodes-column BarcodeSequence --o-per-sample-sequences ${PREFIX}_demux.qza
qiime demux summarize --i-data ${PREFIX}_demux.qza --o-visualization ${PREFIX}_demux.qzv

#use dada2 to remove sequencing errors
echo "Starting dada2"
date
qiime dada2 denoise-single --i-demultiplexed-seqs emp_single_qiime2_demux.qza --p-trim-left 23 --p-trunc-len 125 --o-representative-sequences ${PREFIX}_reps.qza --o-table ${PREFIX}_dada2.qza --o-denoising-stats ${PREFIX}_stats-dada2.qza --p-n-threads 0 --p-min-fold-parent-over-abundance 10

echo "End of script"
date
