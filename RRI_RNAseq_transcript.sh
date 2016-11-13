#!/bin/bash -l

## Robinson Research Institute RNAseq pipeline
## FOR TRANSCRIPTS

## Jimmy Breen (jimmymbreen@gmail.com)

## Requires:
##	FastQC
##	AdapterRemoval
## 	Kallisto
##	Sleuth

### DEVELOPMENT 
## -Convert to ruffus python pipeline
## -Config file in YAML format
## -Phoenix usage
## -Stable log files

# Module loading
. /opt/shared/Modules/3.2.7/init/bash
module load gnu/4.9.2
module load java/java-1.7.09
module load fastQC/0.11.2
#module load htseq/0.6.1p1 ## DEPRECIATED
module load parallel

## Directory setup
base=$(pwd)
DATA=$base/Data
QUANT=$base/2_kallisto
TRIM=$base/1_AdapterRemoval
QC=$base/0_FastQC

## Custom parameters and programs
## - Turn this into YAML config file for python pipeline
ar=/localscratch/Programs/adapterremoval2-20160217-git~cf3b668/build/AdapterRemoval
kallisto=/localscratch/Programs/kallisto_linux-v0.42.4/kallisto
salmon=/localscratch/Programs/Salmon-0.7.2_linux_x86_64/bin/salmon
threads=32

# Transcript References
hg38_trans=/localscratch/Refs/human/hg38_hg20_GRCh38p5/gencode.v24.lncRNA_transcripts_plus_ERCC.fa.gz
hg38_map=
mm10_map=/localscratch/Refs/mouse/mm38.genenameMap.map
mm10_trans=/localscratch/Refs/mouse/mm38.rna.fa.gz


# QC using FastQC
mkdir -p $QC
for i in $DATA/*.fastq.gz
 do
	fastqc -t $threads -k 9 $i -o $QC/
done

# AdapterTrimming with AdapterRemoval
mkdir -p $TRIM
for FQGZ in $DATA/*R1_001*.fastq.gz
 do
	$ar --file1 $FQGZ --file2 ${FQGZ/R1_001/R2_001} \
		--output1 $TRIM/$(basename $FQGZ _R1_001.fastq.gz)_trim1.fastq.gz \
		--output2 $TRIM/$(basename $FQGZ _R1_001.fastq.gz)_trim2.fastq.gz \
		--threads $threads --gzip \
		--trimqualities --trimns --minquality 10 --minlength 25
	parallel -j"$threads" "echo {} && gunzip -c {} | wc -l | awk '{d=\$1; print d/4;}'" ::: *_trim*.fastq.gz \
		> $TRIM/project_AdapterRemoval.txt
done

mkdir -p $QUANT
$salmon index -type quasi -p $threads -i $QUANT/transcripts_salmon_idx -t $mm10_trans
for FQGZ in $TRIM/*_trim1*.fastq.gz
 do
	$salmon quant -l ISF -i $QUANT/transcripts_salmon_idx \
		-p $threads -g $mm10_map --useVBOpt \
		-1 $FQGZ -2 ${FQGZ/trim1/trim2} \
		--numBootstraps 100 -o $QUANT/$(basename $FQGZ _trim1.fastq.gz).salmonOut
done


