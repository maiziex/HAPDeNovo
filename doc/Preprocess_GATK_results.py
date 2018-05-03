import numpy as np
from argparse import ArgumentParser
import os
import sys
import pdb
#pdb.set_trace()

parser = ArgumentParser(description="This Script Is Used for Preprocessing DeNovo Mutations from GATK Variant Call")
parser.add_argument('--input_file','-i', help="input filename")
parser.add_argument('--output_file','-o', help="output filename", default='preprocessed_file_byGATK')
parser.add_argument('--depth','-d', help="reads depth")
parser.add_argument('--PL','-PL', help="Genotype Likelihood")
parser.add_argument('--child_id','-c', help="child id")
parser.add_argument('--parent1_id','-p1', help="parent1 id")
parser.add_argument('--parent2_id','-p2', help="parent2 id")

args = parser.parse_args()


def validate_freebayescall_results(vcf_file,output_file,threshold1,threshold2,child_id,parent1_id,parent2_id):
    fw = open(output_file, "w")
    f = open(vcf_file, "r")
    curr = 0
    mean_DP = 0
    for line in f:
        #print(curr)
        curr += 1
        if line[0:2] == "#C":
            data = line.rsplit()
            child_idx = data.index(child_id)
            parent1_idx = data.index(parent1_id)
            parent2_idx = data.index(parent2_id)
            FORMAT_idx = data.index("FORMAT")
        if line[0] != "#":
            data = line.rsplit()
            chr_num = data[0]
            if chr_num == "chrX":
                locus = data[1]
                if locus == "8598739":
                    print(locus)
                FORMAT = data[FORMAT_idx].split(":")
                DP_idx = FORMAT.index("DP")
                PL_idx = FORMAT.index("PL")

                GT_child = data[child_idx].split(":")[0]
                GT_parent1 = data[parent1_idx].split(":")[0]
                GT_parent2 = data[parent2_idx].split(":")[0]
                try:
                    DP_child = int(data[child_idx].split(":")[DP_idx])
                    PL_child = data[child_idx].split(":")[PL_idx]
                    DP_parent2 = int(data[parent2_idx].split(":")[DP_idx])
                    PL_parent2 = data[parent2_idx].split(":")[PL_idx]
                except:
                    DP_child = 0
                    DP_parent2 = 0

                if (GT_child == "0/1" or GT_child == "1/0") and GT_parent2 == "0/0" and DP_child >= threshold1  and DP_parent2 >= threshold1 and (GT_parent1 != "0/1") :
                    if PL_child.split(",")[1] == "0" and PL_parent2.split(",")[0] == "0":
                        child_2 = np.absolute(float(PL_child.split(",")[0]))
                        child_3 = np.absolute(float(PL_child.split(",")[2]))
                        parent2_2 = np.absolute(float(PL_parent2.split(",")[1]))
                        parent2_3 = np.absolute(float(PL_parent2.split(",")[2]))
                        if (child_2 >= threshold2 or child_3 >= threshold2)  and (parent2_2 >= threshold2 or parent2_3 >= threshold2):
                            fw.writelines(chr_num + "\t" + locus + "\t" + GT_child + "\t" + GT_parent1 + "\t" + GT_parent2 + "\n")


            else:
                locus = data[1]
                FORMAT = data[FORMAT_idx].split(":")
                DP_idx = FORMAT.index("DP")
                PL_idx = FORMAT.index("PL")

                GT_child = data[child_idx].split(":")[0]
                GT_parent1 = data[parent1_idx].split(":")[0]
                GT_parent2 = data[parent2_idx].split(":")[0]
                try:
                    DP_child = int(data[child_idx].split(":")[DP_idx])
                    PL_child = data[child_idx].split(":")[PL_idx]
                    DP_parent1 = int(data[parent1_idx].split(":")[DP_idx])
                    PL_parent1 = data[parent1_idx].split(":")[PL_idx]
                    DP_parent2 = int(data[parent2_idx].split(":")[DP_idx])
                    PL_parent2 = data[parent2_idx].split(":")[PL_idx]
                except:
                    DP_child = 0
                    DP_parent1 = 0
                    DP_parent2 = 0

                if (GT_child == "0/1" or GT_child == "1/0") and GT_parent1 == "0/0" and GT_parent2 == "0/0" and DP_child >= threshold1 and DP_parent1 >= threshold1 and DP_parent2 >= threshold1 :
                    if PL_child.split(",")[1] == "0" and PL_parent1.split(",")[0] == "0" and PL_parent2.split(",")[0] == "0":
                        child_2 = np.absolute(float(PL_child.split(",")[0]))
                        child_3 = np.absolute(float(PL_child.split(",")[2]))
                        parent1_2 = np.absolute(float(PL_parent1.split(",")[1]))
                        parent1_3 = np.absolute(float(PL_parent1.split(",")[2]))
                        parent2_2 = np.absolute(float(PL_parent2.split(",")[1]))
                        parent2_3 = np.absolute(float(PL_parent2.split(",")[2]))
                        if (child_2 >= threshold2 or child_3 >= threshold2) and (parent1_2 >= threshold2 or parent1_3 >= threshold2) and (parent2_2 >= threshold2 or parent2_3 >= threshold2):
                            fw.writelines(chr_num + "\t" + locus + "\t" + GT_child + "\t" + GT_parent1 + "\t" + GT_parent2 + "\n")

    print("finished!")
    fw.close()



                
if __name__ == "__main__":
    if len(sys.argv) == 1:
        os.system("python Preprocess_GATK_results.py -h")
    else:
        validate_freebayescall_results(args.input_file,args.output_file,int(args.depth),int(args.PL),args.child_id,args.parent1_id,args.parent2_id)
   


            
            
