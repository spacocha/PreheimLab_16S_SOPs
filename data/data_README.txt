USAGE: Use this folder to store raw data files (fastq) to be processed.

Where to compute: You should do this work in you scratch directory under the project name. All computational research for this project should occur within this folder.
commands for the NSF_EIS project:
cd ~/scratch
mkdir NSF_EIS
cd NSF_EIS

For each type of analysis you do within this project give it a particular name and describe the goals (and eventually the results):
commands:
mkdir 16S_analysis

Once in that directory, initiate the git repository for that work and rename it with the project information:
ml git
git clone https://github.com/spacocha/PreheimLab_16S_SOPs.git
cd PreheimLab_16S_SOPs
<finish this protocol later once I have the scripts in the original repository and can work out the differences.

Now work in the cloned directory to do the analysis.

Structure: In the data folder,  create a new folder with that name as created by the sequencing center. This could be the user name and record for GRCF, or another format for other sequencing centers.. 
The following commands for sequencing file sprehei1_123456:
cd data
mkdir sprehei1_123456

Within that folder, make a folder called FASTQ, this will be either linked to raw data or raw data files itself.
commands:
mkdir sprehei1_123456/FASTQ

Copy or link the files as needed. All raw data should be depositied in ~/data/Raw_data_group folder with the FASTQ files and a mapping file. Next, copy to the data folder, don't link to the original data on data in case of a error. 

cp the file copy command to copy the files you need to your data folder.



