import sys
import os
import pdb
#pdb.set_trace()

from argparse import ArgumentParser
parser = ArgumentParser(description="Checking sample ID for the bam file")
parser.add_argument('--input_bam','-i', help="The bam file used to check sample ID")

args = parser.parse_args()

if __name__ == "__main__":
    if len(sys.argv) == 1:
        os.system("python Check_sampleID.py -h")
    else:
        used_command = "../lib/samtools/samtools view -H " + args.input_bam + " | grep 'RG' > tempRG.txt"
        os.system(used_command)
        f = open("tempRG.txt","r")
        for line in f:
            data = line.rsplit()
            sample_ID = data[1].split(":")[1]
        print("The sample ID for this BAM file: " + sample_ID)



