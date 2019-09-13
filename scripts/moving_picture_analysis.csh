#!/bin/sh
#
#SBATCH --job-name=moving_pictures
#SBATCH --time=72:00:00
#SBATCH --ntasks=5
#SBATCH --cpus-per-task=1
#SBATCH --partition=lrgmem
#SBATCH --mem-per-cpu=20G

#Define the table and reps, either single run DADA2 output, or merged table
TABLE=combined_dada2.qza
REPS=combined_reps.qza

#Look at the sequencing depth of the samples
#Choose the most appropriate depth
#Either the lowest count sample or 5000 (minimum) which ever is higher
#Find the coverage with the 
#qiime feature-table summarize
DEPTH=5000
CORE=core-metrics-single
METADATA=sample-metadata.tsv 
PREFIX=emp_single_MPA
CLASSI=gg-13-8-99-515-806-nb-classifier.qza

#load qiime module
module load qiime2/2018.8

#Make a tmp folder on scratch to use if it doesn't already exist
#mkdir /scratch/users/sprehei1@jhu.edu/tmp
#Don't use relative paths in the next line: use pwd -P for true path
export TMPDIR='/scratch/users/sprehei1@jhu.edu/tmp'

#echo the time for each
echo "Starting moving picture tutorial analysis"
date

#summarize
echo "Summarize"
date

#echo "Starting alignment and tree"
#date
qiime alignment mafft --i-sequences ${REPS} --o-alignment ${PREFIX}_reps_alignment.qza
qiime alignment mask --i-alignment ${PREFIX}_reps_alignment.qza --o-masked-alignment ${PREFIX}_reps_alignment_masked.qza
qiime phylogeny fasttree --i-alignment ${PREFIX}_reps_alignment_masked.qza --o-tree ${PREFIX}_reps_alignment_masked_unrooted_tree.qza
qiime phylogeny midpoint-root --i-tree ${PREFIX}_reps_alignment_masked_unrooted_tree.qza --o-rooted-tree ${PREFIX}_reps_alignment_masked_rooted_tree.qza

#alpha diversity
echo "Starting alpha diversity"
date
qiime diversity core-metrics-phylogenetic --i-phylogeny ${PREFIX}_reps_alignment_masked_rooted_tree.qza --i-table $TABLE --p-sampling-depth $DEPTH --output-dir $CORE --m-metadata-file ${METADATA}

#group significance
echo "Starting alpha diversity significance"
date
qiime diversity alpha-group-significance --i-alpha-diversity ${CORE}/faith_pd_vector.qza --m-metadata-file $METADATA --o-visualization ${CORE}/faith-pd-group-significance.qzv
qiime diversity alpha-group-significance --i-alpha-diversity ${CORE}/evenness_vector.qza --m-metadata-file $METADATA --o-visualization ${CORE}/evenness-group-significance.qzv

echo "Beta diversity"
date

#plots
echo "Plots"
date
qiime emperor plot --i-pcoa ${CORE}/unweighted_unifrac_pcoa_results.qza --m-metadata-file $METADATA --o-visualization ${CORE}/unweighted-unifrac-emperor.qzv
qiime emperor plot --i-pcoa ${CORE}/weighted_unifrac_pcoa_results.qza --m-metadata-file $METADATA --o-visualization ${CORE}/weighted-unifrac-emperor.qzv
qiime emperor plot --i-pcoa ${CORE}/bray_curtis_pcoa_results.qza --m-metadata-file $METADATA --o-visualization ${CORE}/bray-curtis-emperor.qzv

#alpha
echo "Alpha rarefaction"
date
qiime diversity alpha-rarefaction --i-table ${TABLE} --i-phylogeny ${PREFIX}_reps_alignment_masked_rooted_tree.qza --p-max-depth ${DEPTH} --m-metadata-file ${METADATA} --o-visualization ${PREFIX}_alpha_rarefaction.qzv

#taxonomy
echo "Starting taxonomic analysis"
date
qiime feature-classifier classify-sklearn --i-classifier ${CLASSI} --i-reads $REPS --o-classification ${PREFIX}_taxonomy.qza
qiime metadata tabulate --m-input-file ${PREFIX}_taxonomy.qza --o-visualization ${PREFIX}_taxonomy.qzv
qiime taxa barplot --i-table $TABLE --i-taxonomy ${PREFIX}_taxonomy.qza --m-metadata-file $METADATA --o-visualization ${PREFIX}_taxa-bar-plots.qzv

echo "End of script"
date
