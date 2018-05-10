import pdb
#pdb.set_trace()
import numpy as np
from argparse import ArgumentParser
import os
import sys

parser = ArgumentParser(description="This Script Is Used for Preprocessing DeNovo Mutations from DeNovoGear")
parser.add_argument('--input_file','-i', help="input filename")
parser.add_argument('--output_file','-o', help="output filename", default='preprocessed_file_bydenovogear')

args = parser.parse_args()

def process_denovogear_vcf(denovogear_vcf,output_file):
    fw = open(output_file,"w")
    f = open(denovogear_vcf, "r")
    curr = 0
    ACGT = ["AA","GG","CC","TT"]
    for line in f:
        #print(curr)
        curr += 1
        if line[0] != "#":
            data = line.rsplit()
            chr_num =  data[0]
            GT_idx = data[8].split(":").index("DNM_CONFIG(child/mom/dad)")
            GT = data[9].split(":")[GT_idx]
            if GT.split("/")[1] == GT.split("/")[2] and GT.split("/")[1] in ACGT and (GT.split("/")[1][0] == GT.split("/")[0][0] or GT.split("/")[1][0] == GT.split("/")[0][1]) and GT.split("/")[0][0] != GT.split("/")[0][1] and GT.split("/")[1][0] == GT.split("/")[1][1]:
                try:
                    chrnum = chr_num[3:]
                    locus = data[1]
                    fw.writelines(chr_num + "\t" + locus + "\t" + GT + "\n")
                except:
                    pass

    fw.close()
    f.close()



if __name__ == "__main__":
    input_file = args.input_file
    output_file = args.output_file
    process_denovogear_vcf(input_file,output_file)
