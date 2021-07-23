source("../config")

samples = read.table(paste0("/bettik/chuffarf/geo_submission/", gse, "/GSE1full/counts/md5.geo.txt"))
head(samples)
dim(samples)

samples$sample_name =         substr(samples[,2], 1, 18)
samples$title =               samples$sample_name
samples$source_name =         "liver"
samples$organism =            paste0(species, "_", version) 
samples$genetic_background =  substr(samples[,2], 1, 6)
samples$diet =                substr(samples[,2], 8, 13)
samples$replicate =           substr(samples[,2], 15, 18)
samples$processed_data_file = samples[,2]
samples$raw_file1 =           paste0(samples$sample_name, "_R1.fastq.gz")
samples$raw_file2 =           paste0(samples$sample_name, "_R2.fastq.gz")

samples = samples[,-(1:2)] 
head(samples)
WriteXLS::WriteXLS(samples, "01_samples.xlsx")







proc_data_files = read.table(paste0("/bettik/chuffarf/geo_submission/", gse, "/GSE1full/counts/md5.geo.txt"))
head(proc_data_files)
dim(proc_data_files)

proc_data_files$filename = proc_data_files[,2]
proc_data_files$filetype = "counts"
proc_data_files$checksum = proc_data_files[,1]

proc_data_files = proc_data_files[,-(1:2)] 
head(proc_data_files)
WriteXLS::WriteXLS(proc_data_files, "02_proc_data_files.xlsx")








raw_files = read.table(paste0("/bettik/chuffarf/geo_submission/", gse, "/GSE1full/fastq/md5.geo.txt"))
head(raw_files)
dim(raw_files)

raw_files$filename =         raw_files[,2]
raw_files$filetype =         "fastq"
raw_files$checksum =         raw_files[,1]
raw_files$instrument_model = "NextSeq500"
raw_files$single_or_paired = "paired-end"

raw_files = raw_files[,-(1:2)] 
head(raw_files)
WriteXLS::WriteXLS(raw_files, "03_raw_files.xlsx")









paired_end_experiments = data.frame(filename1=paste0(samples$sample_name, "_R1.fastq.gz"), filename2=paste0(samples$sample_name, "_R2.fastq.gz"))
head(paired_end_experiments)
WriteXLS::WriteXLS(paired_end_experiments, "04_paired_end_experiments.xlsx")



