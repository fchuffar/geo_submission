cd ~/projects/rat_den/results/rnaseq_kurma
source config
ssh cargo

# Metadata spreadsheet
# https://www.ncbi.nlm.nih.gov/geo/info/examples/seq_template.xlsx

GSE_TARGET_NAME=GSE1full 

# Transfering files
cd /home/fchuffar/projects/${datashare}/${gse}/
ls -lha raw/*R1.fastq.gz raw/*R2.fastq.gz
# cat raw/delivered/md5.summer.txt
ls -lha *_${gtf_prefix}_stranded${strand}_classiccounts.txt
mkdir -p /bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/fastq
mkdir -p /bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/counts
rsync -auvP --copy-links \
  /home/fchuffar/projects/${datashare}/${gse}/*_${gtf_prefix}_stranded${strand}_classiccounts.txt \
  /bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/counts/.
rsync -cauvP --copy-links \
  /home/fchuffar/projects/${datashare}/${gse}/raw/*R1.fastq.gz \
  /home/fchuffar/projects/${datashare}/${gse}/raw/*R2.fastq.gz \
  /bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/fastq/.

ls -lha /bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/*

# MD5
cd /bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/counts
md5sum *_${gtf_prefix}_stranded${strand}_classiccounts.txt > md5.geo.txt
cd /bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/fastq
md5sum *.fastq.gz > md5.geo.txt


# Put metadata
cd ~/projects/${project}/results/${gse}/geo_submission
Rscript generate_metadata.R 

cd ~/projects/${project}/results/${gse}/geo_submission
open seq_template.xlsx


rsync -auvP seq_template.xlsx cargo:/bettik/chuffarf/geo_submission/${gse}/${GSE_TARGET_NAME}/.

# Creating archive
cd /bettik/chuffarf/geo_submission/${gse}/
ls -lha ${GSE_TARGET_NAME}/*
 
tar -cvf ${GSE_TARGET_NAME}.tar ${GSE_TARGET_NAME}


# Put on GEO
ssh cargo
cd /bettik/chuffarf/geo_submission/${gse}/
lftp ftp-private.ncbi.nlm.nih.gov
# identification requiered...
put ${GSE_TARGET_NAME}.tar

