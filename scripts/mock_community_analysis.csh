#!/bin/sh
#
#SBATCH --job-name=moving_pictures
#SBATCH --time=72:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=lrgmem
#SBATCH --mem-per-cpu=20G

#load qiime module
module load qiime2/2018.8

source ./mock_community_analysis.config

#echo the time for each
echo "Starting mock community analysis"
date

qiime tools export --input-path ${TABLE} --output-path ${PREFIX}_feature_table

qiime tools export --input-path ${REPS} --output-path ${PREFIX}_rep-seqs

biom convert -i ${PREFIX}_feature_table/feature-table.biom -o ${PREFIX}_feature_table/feature-table.biom.txt --table-type "OTU table" --to-tsv

#These will only work if you have the path to scripts dir in PATH variable 
map2mock.pl ${MOCK} ${PREFIX}_rep-seqs/dna-sequences.fasta > ${PREFIX}_rep-seqs/dna-sequences.map

map2mock_mat.pl ${PREFIX}_rep-seqs/dna-sequences.map ${PREFIX}_feature_table/feature-table.biom.txt > ${PREFIX}_feature_table/feature-table.biom.map

#Ideally you put some kind of script to make the comparison automatically, not just in excel
#However, until that point, open the feature-table.biom.map in excell and add the known sequence values
#Then compare observed and expected

echo "End of script"
date

