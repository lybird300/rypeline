
import yaml
import os
import subprocess
import argparse

# Help manual using argparse
def get_args_rype():    
    parser = argparse.ArgumentParser(description='Pipeline for RNAseq analysis at RRI')
    parser.add_argument("input", help="YAML describing read data information")
    parser.add_argument("reference", help="Index name: [default: hg38]")
    parser.add_argument("-p", "--program", default="fastqc",
        help="program to start executing at: fastq_dump, fastqc, bbmerge, \
		 salmon, tophat2, STAR, hisat2, HTseq, eXpress, DESeq2, EdgeR, cleanup \
		 [default: fastq_dump] (You must have run the pipeline up \
		 to the chosen starting program for this option to work)")
    parser.add_argument("-v", "--verbose", action="store_true", 
        help="Runs program in verbose mode which enables all debug output.")
    parser.add_argument("--ena", action="store_true", 
        help="Skips fastq_dump for every file.")
    parser.add_argument("-d","--fastqdir", default=".", 
        help="Specify the raw fastq directory")
    parser.add_argument("-t","--threads", type=int, default = 4,
        help="Specify the number of threads that should be used.")
    parser.add_argument("-s","--skip", action="store_true", 
        help="Continue even if errors occur.")

    return parser.parse_args()

def parse_yaml():

def call_sra_fasq_dump():

def call_qc():

def call_trim():

def call_algin():
	if tophat or STAR or hisat2

def call_align_free():

def call_quant():

def call_cleanup():


def stats_log():

