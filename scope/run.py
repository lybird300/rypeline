
import yaml
import rypeline

# Read in config and run files
with open('config.yaml', 'r') as config:
	params = yaml.load(config)

with open('run.yaml', 'r') as run:
	samples = yaml.load(run)

