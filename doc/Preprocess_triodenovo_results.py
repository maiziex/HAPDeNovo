import numpy as np
from argparse import ArgumentParser
import os
import sys
import pdb
#pdb.set_trace()

parser = ArgumentParser(description="This Script Is Used for Preprocessing DeNovo Mutations from TrioDeNovo")
parser.add_argument('--input_file','-i', help="input filename")
parser.add_argument('--output_file','-o', help="output filename", default='preprocessed_file_byFreeBayes')
parser.add_argument('--child_id','-c', help="child id")
parser.add_argument('--parent1_id','-p1', help="parent1 id")
parser.add_argument('--parent2_id','-p2', help="parent2 id")

args = parser.parse_args()

def preprocess_triodenovo_results(triodenovo_file,output_file,child_id,parent1_id,parent2_id):
    fw = open(output_file, "w")
    f = open(triodenovo_file, "r")
    for line in f:
        if line[0:2] == "#C":
            data = line.rsplit()
            father_idx = data.index(parent1_id)
            mother_idx = data.index(parent2_id)
            child_idx = data.index(child_id)
        if line[0] != "#":
            data = line.rsplit()
            chr_name = data[0]
            try:
                chr_num = int(chr_name[3:])
                locus = data[1]
                ref = data[3]
                alt = data[4]
                father_GT = data[father_idx].split(":")[0]
                mother_GT = data[mother_idx].split(":")[0]
                child_GT = data[child_idx].split(":")[0]
                if father_GT[0] == father_GT[2] and mother_GT[0] == mother_GT[2] and father_GT[0] == ref and mother_GT[0] == ref and child_GT[0] == ref and child_GT[2] == alt:
                    fw.writelines(chr_name + "\t" + locus + "\t" + child_GT + "\t" + father_GT + "\t" + mother_GT + "\n")

                if father_GT[0] == father_GT[2] and mother_GT[0] == mother_GT[2] and father_GT[0] == ref and mother_GT[0] == ref and child_GT[0] == alt and child_GT[2] == ref:
                    fw.writelines(chr_name + "\t" + locus + "\t" + child_GT + "\t" + father_GT + "\t" + mother_GT + "\n")
            except:
                if chr_name == "chrX" or chr_name == "chrY":
                    locus = data[1]
                    ref = data[3]
                    alt = data[4]
                    father_GT = data[father_idx].split(":")[0]
                    mother_GT = data[mother_idx].split(":")[0]
                    child_GT = data[child_idx].split(":")[0]
                    if father_GT[0] == father_GT[2] and mother_GT[0] == mother_GT[2] and father_GT[0] == ref and mother_GT[0] == ref and child_GT[0] == ref and child_GT[2] == alt:
                        fw.writelines(chr_name + "\t" + locus + "\t" + child_GT + "\t" + father_GT + "\t" + mother_GT + "\n")

                    if father_GT[0] == father_GT[2] and mother_GT[0] == mother_GT[2] and father_GT[0] == ref and mother_GT[0] == ref and child_GT[0] == alt and child_GT[2] == ref:
                        fw.writelines(chr_name + "\t" + locus + "\t" + child_GT + "\t" + father_GT + "\t" + mother_GT + "\n")

    fw.close()
    f.close()

if __name__ == "__main__":
    if len(sys.argv) == 1:
        os.system("python Preprocess_triodenovo_results.py -h")
    else:
        preprocess_triodenovo_results(args.input_file,args.output_file,args.child_id,args.parent1_id,args.parent2_id)
