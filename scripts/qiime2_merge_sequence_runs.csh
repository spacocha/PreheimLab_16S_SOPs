#!/bin/sh
#
#SBATCH --job-name=QIIME2_merge
#SBATCH --time=72:00:00

#Path to all of the files, or you can link to current directory
#with file1.txt, file2.txt and file3.txt with
#ln -s path/to/run1_dada2.qza run1_dada2.qza
#ln -s path/to/run2_dada2.qza run2_dada2.qza
#ln -s path/to/run3_dada2.qza run3_dada2.qza
RUN1_DADA2=run1_dada2.qza
RUN2_DADA2=run2_dada2.qza
RUN3_DADA2=run3_dada2.qza
#Merge the rep seqs too
#ln -s path/to/run1_reps.qza run1_reps.qza
#ln -s path/to/run2_reps.qza run2_reps.qza
#ln -s path/to/run3_reps.qza run3_reps.qza
RUN1_REPS=run1_reps.qza
RUN2_REPS=run2_reps.qza
RUN3_REPS=run3_reps.qza
#Specify path to the mapping file
#This must be checked by the KEIMEI in google sheets and be approved QIIME2 format
#This should be in the current working directory
#You can combine them all by cat
#cat path/to/run1_metadata.txt path/to/run2_metadata.txt path/to/run3_metadata.txt > sample-metadata.tsv
METADATA=sample-metadata.tsv

#Define an appropriate prefix for this analysis
PREFIX=combined

#load qiime module
module load qiime2/2018.8

#Make a tmp folder on scratch to use if it doesn't already exist
#mkdir /scratch/users/sprehei1@jhu.edu/tmp
#Don't use relative paths in the next line: use pwd -P for true path
export TMPDIR='/scratch/users/sprehei1@jhu.edu/tmp'
#echo the time for each
echo "Starting qiime2 merge"
date

#merge multiple sequencing run dada2 files with the following command
echo "Starting merge"
date
#Check TMPDIR path is working
echo $TMPDIR
qiime feature-table merge --i-tables ${RUN1_DADA2} --i-tables ${RUN2_DADA2} --i-tables ${RUN3_DADA2} --o-merged-table ${PREFIX}_dada2.qza
qiime feature-table merge-seqs --i-data ${RUN1_REPS} --i-data ${RUN2_REPS} --i-data ${RUN3_REPS} --o-merged-data ${PREFIX}_reps.qza

echo "Starting merge"
date
#Check TMPDIR path is working
echo $TMPDIR

qiime feature-table summarize --i-table ${PREFIX}_dada2.qza --o-visualization ${PREFIX}_dada2_summarize.qzv --m-sample-metadata-file ${METADATA}
echo "End of Script"
date
