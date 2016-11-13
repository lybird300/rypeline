
from subprocess import Popen PIPE
from ruffus import *

def get_yaml_params(config):
    """
    Get all the parameters and filenames from YAML
    """
    ii = open(input_file)
    oo = open(output_file, "w")

def bam_read_count(bamfile):
    """ Return a tuple of the number of mapped and unmapped reads
    and proportion in a bam file
    """
    p = Popen(['samtools', 'idxstats', bamfile], stdout=PIPE)
    mapped = 0
    unmapped = 0
    for line in p.stdout:
        rname, rlen, nm, nu = line.rstrip().split()
        mapped += int(nm)
        unmapped += int(nu)
    prop = mapped/(mapped + unmapped)
    return (mapped, unmapped, prop)

def run_fastqc(input_file, output_file):
    """
    Run fastqc on file and create a report
    """
    ii = open(input_file)
    oo = open(output_file, "w")

@follows(run_fastqc, mkdir( 'my/directory/' ))
def adapter_trim(raw_r1, raw_r1, trimmed_r1, trimmed_r2):
    """
    
    """
    ii = open(input_file)
    oo = open(output_file, "w")

@follows(adapter_trim, mkdir( 'my/directory/' ))
def map_sequence(trimmed_r1, trimmed_r2, sorted_bam):
    """

    """
    ii = open(input_file)
    oo = open(output_file, "w")

@follows(adapter_trim, mkdir( 'my/directory/' ))
def quant_feature_counts(trimmed_r1, trimmed_r2, output_bam):
    """

    """
    ii = open(input_file)
    oo = open(output_file, "w")
