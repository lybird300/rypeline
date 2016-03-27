# Rypeline

Jimmy Breen, Ben Mayne

RNAseq pipeline for SCOPE study

![RNAseq Pipeline Flow Diagram](./RNAseq_pipeline_workflow.pdf) 

## Pipeline Requirements

- Python
- Ruffus (http://www.ruffus.org.uk)
- matplotlib
- numpy
- R
- bbtools (https://sourceforge.net/projects/bbmap/)

We recommend running under virtual environments:
[http://docs.python-guide.org/en/latest/dev/virtualenvs/](http://docs.python-guide.org/en/latest/dev/virtualenvs/)

### Linux:

```sudo apt-get install python-pip rstudio```  
```pip install ruffus HTSeq matplotlib numpy```  

For bbtools, install into your favourite tools directory and add to PATH:  
```wget http://downloads.sourceforge.net/project/bbmap/BBMap_35.85.tar.gz```  
```tar xvzf BBMap_35.85.tar.gz``` 

### MacOSX:
We recommend installing package manager homebrew  
```/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```  
```brew install Caskroom/cask/rstudio```  

If pip is installed then:  
```pip install ruffus HTSeq matplotlib numpy```  

If pip is not installed, install it:  
```wget https://bootstrap.pypa.io/get-pip.py```  
```python get-pip.py```  

For bbtools, install into your favourite tools directory and add to PATH:  
```wget http://downloads.sourceforge.net/project/bbmap/BBMap_35.85.tar.gz```  
```tar xvzf BBMap_35.85.tar.gz```  

## RNAseq analysis components

### Alignment-free (recommended)

- Salmon (https://salmon.readthedocs.org/en/latest/salmon.html)
- EdgeR (https://bioconductor.org/packages/release/bioc/html/edgeR.html)

### Alignment


