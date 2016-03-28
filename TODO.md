# Rypeline to do (Ben & Jimmy)

- Complete and test functions in Rypeline.py module file. Each function calls subprocess but parses params and
  filenames from the accompanying config.yaml. 
	- YAML parse function -> creates the data objects for the pipeline (R1.fastq.gz etc)
	- fastq dump from sra files
	- fastqc (should be pretty easy)
	- trimming function -> which can be two choices
	- aligment -> with even more choices. Config file might change here
	- afree -> Do we do kallisto as well?
	- quant -> only for alignment steps, additional choices
	- DE analysis
		- R scripts need to be developed here, although im happy to have something written in python
		- Current EdgeR and DESeq2
		- We might just stop the pipeline at quant/afree, and then just do DE analysis mannually
- Cleanup function that gets rid of files and directories when the pipeline fails
- With the verbose mode we will get logs of each process
- Pipeline needs to be stable enough to be started from each stage
	- e.g. If alignment files because the server loses connection, I want to start from there
- Each step on the pipeline needs to create a directory for processed files
- Only bams and result files (from DE analysis) to be kept (to save space). Everything compressed if possible

