#!/bin/bash -l

## Robinson Research Institute small RNAseq pipeline
## FOR TRANSCRIPTS

## Jimmy Breen (jimmymbreen@gmail.com)

## Requires:
##	FastQC
##	AdapterRemoval

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
module load bowtie/0.10.1

## Directory setup
base=$(pwd)
DATA=$base/Data
QC=$base/0_FastQC
TRIM=$base/1_AdapterRemoval
ALIGN=$base/2_bowtie
ANNOT=$base/3_mirbase


## Custom parameters and programs
## - Turn this into YAML config file for python pipeline
ar=/localscratch/Programs/adapterremoval2-20160217-git~cf3b668/build/AdapterRemoval
threads=32

# Transcript References
hg38_trans=/localscratch/Refs/human/hg38_hg20_GRCh38p5/gencode.v24.lncRNA_transcripts_plus_ERCC.fa.gz
hg38_map=
mm10_genome=/localscratch/Refs/mouse/genome.fa
mm10_map=/localscratch/Refs/mouse/mm38.genenameMap.map
mm10_trans=/localscratch/Refs/mouse/mm38.rna.fa.gz
miRnaRef=/localscratch/Refs/mouse/mmu.gff3
ADAPTER=TGGAATTCTCGGGTGCCAAGG

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

#       $ar --file1 $FQGZ --output1 $TRIM/$(basename $FQGZ _R1_001.fastq.gz)_T.fastq.gz \
#               --threads $threads --gzip \
#               --trimqualities --trimns \
#               --minquality 10 --minlength 10 \
#               --adapter1 TGGAATTCTCGGGTGCCAAGG

        cutadapt --adapter=$ADAPTER --minimum-length=8 \
                --untrimmed-output="$TRIM/$(basename $FQGZ _R1_001.fastq.gz)_untrimmed.fastq.gz" \
                -o $TRIM/$(basename $FQGZ _R1_001.fastq.gz)_clean.fastq.gz \
                -m 17 --overlap=8 $FQGZ 1> $TRIM/$(basename $FQGZ _R1_001.fastq.gz)_stats.txt
#       zcat $FQGZ | fastx_clipper -Q 33 -a $ADAPTER \
#               -l 17 -z -v -i - -o $TRIM/$(basename $FQGZ _R1_001.fastq.gz)_clipped.fastq.gz

#       zcat $TRIM/$(basename $FQGZ _R1_001.fastq.gz)_clipped.fastq.gz | \
#               fastx_collapser -Q33 -i - -o $TRIM/$(basename $FQGZ _R1_001.fastq.gz).collapsed.fa
done

parallel -j"$threads" "echo {} && gunzip -c {} | wc -l | awk '{d=\$1; print d/4;}'" ::: $TRIM/*_clean.fastq.gz \
                > $TRIM/project_clipped.txt

# Alignment
mkdir -p $ALIGN
bowtie-build $mm10_genome $ALIGN/genome
for file in $TRIM/*_clean.fastq.gz
 do
        bowtie -f -v0 -k 20 -m 20 --best --strata --sam \
              -p $threads $ALIGN/genome \
              $file $ALIGN/$(basename $file _clean.fastq.gz).bowtie_v0_k20m20.sam
        samtools view -Sb \
              $ALIGN/$(basename $file _clean.fastq.gz).bowtie_v0_k20m20.sam \
              > $ALIGN/$(basename $file _clean.fastq.gz).mapped.bam
        samtools sort $ALIGN/$(basename $file _clean.fastq.gz).mapped.bam \
              $ALIGN/$(basename $file _clean.fastq.gz).mapped.sorted

        rm $ALIGN/$(basename $file _clean.fastq.gz).bowtie_v0_k20m20.sam
done

# MirBASE annotation
mkdir -p $ANNOT
for bam in $ALIGN/*.mapped.sorted.bam
 do
        intersectBed -bed -wao -abam $bam \
              -b $miRnaRef -s -f .5 -sorted > $ANNOT/$(basename $file .mapped.sorted.bam).miRNAs.bed
        awk '$NF=="0"' $ANNOT/$(basename $file .mapped.sorted.bam).miRNAs.bed \
         > $ANNOT/$(basename $file .mapped.sorted.bam).noMiRNAs.bed
done
