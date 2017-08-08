from collections import defaultdict
import os.path
import sys
import gzip
import os

from argparse import ArgumentParser

parser = ArgumentParser(description="HAPDeNovo")
parser.add_argument('--chr_start','-c_start',type=int,help="chromosome start from", default=1)
parser.add_argument('--chr_end','-c_end',type=int,help="chromosome end at", default=1)
parser.add_argument('--depth','-d', type=int, help="Filter Depth", default=1)
parser.add_argument('--input_file','-i', help="Input DNMs file from other tools like FreeBayes, TrioDeNovo, and etc")
parser.add_argument('--output_file_prefix','-o', help="output file prefix", default='HAPDeNovo_Results')
parser.add_argument('--out_dir','-o_dir', help="Directory to store outputs", default='HAPDeNovo_Results')
parser.add_argument('--child_id','-c', help="child id")
parser.add_argument('--parent1_id','-p1', help="parent1 id")
parser.add_argument('--parent2_id','-p2', help="parent2 id")

args = parser.parse_args()



class sample(object):
    def __init__(self,GT_hp1,RO_hp1,AO_hp1,GT_hp2,RO_hp2,AO_hp2):
        self.GT_hp1 = GT_hp1
        self.RO_hp1 = RO_hp1
        self.AO_hp1 = AO_hp1
        self.GT_hp2 = GT_hp2
        self.AO_hp2 = AO_hp2
        self.RO_hp2 = RO_hp2


def find_lowconf(input_file):
    lowconf_dict = defaultdict(int)
    f = open(input_file,"r")
    curr = 0
    for line in f:
        curr += 1
        if line[:2] == "#C":
            data = line.rsplit()
            format_idx = data.index("FORMAT")
        elif line[0]!="#":
            samples = []
            data = line.rsplit()
            FORMAT = data[format_idx].split(":")
            try:
                AD_idx = FORMAT.index("AD")
            except:
                try:
                    RO_idx = FORMAT.index("RO")
                    AO_idx = FORMAT.index("AO")
                except:
                    print("need AD or RO,AO field for FORMAT of vcf! exit!\n")
                    sys.exit()

            try:
                for field in [9,12,15]:
                    GT_hp1 = data[field].split(":")[0]
                    if GT_hp1 == "./." or GT_hp1 == ".":
                        lowconf_dict[int(data[1])] = 1
                        break

                    GT_hp2 = data[field+1].split(":")[0]
                    if GT_hp2 == "./." or GT_hp2 == ".":
                        lowconf_dict[int(data[1])] = 1
                        break
            except:
                pass

    return lowconf_dict


def find_highconf(input_file,reads_depth):
    highconf_locus = []
    highconf_parents_locus = []
    highconf_dict = defaultdict(list)
    highconf_parents_dict = defaultdict(list)
    highconf_dict2 = defaultdict(int)
    highconf_parents_dict2 = defaultdict(int)
    count = 0
    f = open(input_file,"r")
    curr = 0
    for line in f:
        print(curr)
        curr += 1
        if line[:2] == "#C":
            data = line.rsplit()
            format_idx = data.index("FORMAT")
        elif line[0]!="#":
            samples = []
            GT_hp1_count = defaultdict()
            GT_hp2_count = defaultdict()
            data = line.rsplit()
            FORMAT = data[format_idx].split(":")
            try:
                AD_idx = FORMAT.index("AD")
            except:
                try:
                    RO_idx = FORMAT.index("RO")
                    AO_idx = FORMAT.index("AO")
                except:
                    print("need AD or RO,AO field for FORMAT of vcf! exit!\n")
                    sys.exit()

            try:
                chr_num = data[0]
                range_fields = [9,12,15]
                for field in range_fields:
                    GT_hp1 = data[field].split(":")[0]
                    if GT_hp1 == "./." or GT_hp1 == ".":
                        flag_break = 1
                        break

                    if 'RO_idx' in locals():
                        RO_hp1 = int(data[field].split(":")[RO_idx])
                        AO_hp1 = int(data[field].split(":")[AO_idx])
                    if 'AD_idx' in locals():
                        RO_hp1 = int(data[field].split(":")[AD_idx].split(",")[0])
                        AO_hp1 = int(data[field].split(":")[AD_idx].split(",")[1])


                    GT_hp2 = data[field+1].split(":")[0]
                    if GT_hp2 == "./." or GT_hp2 == ".":
                        flag_break = 1
                        break
                     
                    if 'RO_idx' in locals():
                        RO_hp2 = int(data[field+1].split(":")[RO_idx])
                        AO_hp2 = int(data[field+1].split(":")[AO_idx])
                    if 'AD_idx' in locals():
                        RO_hp2 = int(data[field+1].split(":")[AD_idx].split(",")[0])
                        AO_hp2 = int(data[field+1].split(":")[AD_idx].split(",")[1])
  
                     
                    new_sample = sample(GT_hp1,RO_hp1,AO_hp1,GT_hp2,RO_hp2,AO_hp2)
                    samples.append(new_sample)
                  
                if flag_break == 1:
                    flag_break = 0
                    continue
                count += 1
                # first
                if (samples[1].GT_hp1=="0/0" or samples[1].GT_hp1=="1/1") and (samples[1].GT_hp2=="0/0" or samples[1].GT_hp2=="1/1") and  (samples[2].GT_hp1=="0/0" or samples[2].GT_hp1=="1/1") and (samples[2].GT_hp2=="0/0" or samples[2].GT_hp2=="1/1"):
                    for ii in range(1,3):
                        if samples[ii].GT_hp1=="0/0":
                            GT_hp1_count[ii] = samples[ii].RO_hp1
                        elif samples[ii].GT_hp1=="1/1":
                            GT_hp1_count[ii] = samples[ii].AO_hp1

                        if samples[ii].GT_hp2=="0/0":
                            GT_hp2_count[ii] = samples[ii].RO_hp2
                        elif samples[ii].GT_hp2=="1/1":
                            GT_hp2_count[ii] = samples[ii].AO_hp2
                        

                    if GT_hp1_count[1] >=reads_depth and GT_hp2_count[1] >=reads_depth and GT_hp1_count[2] >=reads_depth and GT_hp2_count[2]>=reads_depth:
                        highconf_parents_locus.append(data[1])
                        highconf_parents_dict[int(data[1])] = [samples[0].RO_hp1,samples[0].AO_hp1,samples[0].RO_hp2,samples[0].AO_hp2,samples[1].RO_hp1,samples[1].AO_hp1,samples[1].RO_hp2,samples[1].AO_hp2,samples[2].RO_hp1,samples[2].AO_hp1,samples[2].RO_hp2,samples[2].AO_hp2] 
                        highconf_parents_dict2[int(data[1])] = 1

                # second
                if (samples[0].GT_hp1=="0/0" or samples[0].GT_hp1=="1/1") and (samples[0].GT_hp2=="0/0" or samples[0].GT_hp2=="1/1") and (samples[1].GT_hp1=="0/0" or samples[1].GT_hp1=="1/1") and (samples[1].GT_hp2=="0/0" or samples[1].GT_hp2=="1/1") and  (samples[2].GT_hp1=="0/0" or samples[2].GT_hp1=="1/1") and (samples[2].GT_hp2=="0/0" or samples[2].GT_hp2=="1/1"):
                    for ii in range(3):
                        if samples[ii].GT_hp1=="0/0":
                            GT_hp1_count[ii] = samples[ii].RO_hp1
                        elif samples[ii].GT_hp1=="1/1":
                            GT_hp1_count[ii] = samples[ii].AO_hp1

                        if samples[ii].GT_hp2=="0/0":
                            GT_hp2_count[ii] = samples[ii].RO_hp2
                        elif samples[ii].GT_hp2=="1/1":
                            GT_hp2_count[ii] = samples[ii].AO_hp2
                        
       

                    if GT_hp1_count[0] >=reads_depth and GT_hp2_count[0]>=reads_depth and GT_hp1_count[1] >=reads_depth and GT_hp2_count[1] >=reads_depth and GT_hp1_count[2] >=reads_depth and GT_hp2_count[2]>=reads_depth:
                        highconf_locus.append(data[1])
                        highconf_dict[int(data[1])] = [samples[0].RO_hp1,samples[0].AO_hp1,samples[0].RO_hp2,samples[0].AO_hp2,samples[1].RO_hp1,samples[1].AO_hp1,samples[1].RO_hp2,samples[1].AO_hp2,samples[2].RO_hp1,samples[2].AO_hp1,samples[2].RO_hp2,samples[2].AO_hp2] 
                        highconf_dict2[int(data[1])] = 1 


            except:
                count += 1
                pass
      

    return (highconf_locus,highconf_dict,highconf_dict2,highconf_parents_locus,highconf_parents_dict,highconf_parents_dict2)


def find_all_loci_3hps_vcf(threehps_file):
    all_loci_dict = defaultdict(int)
    f = open(threehps_file,"r")
    for line in f:
        if line[0]!="#":
            data = line.rsplit()
            chr_num = data[0]
            locus = data[1]
            all_loci_dict[(chr_num,locus)] = 1

    return all_loci_dict


def get_denovo_raw_results(denovo_file):
    denovo_raw = defaultdict(int)
    f = open(denovo_file, "r")
    for line in f:
        data = line.rsplit()
        chr_num = data[0]
        locus = data[1]
        denovo_raw[(chr_num,locus)] = 1
    return denovo_raw


def find_denovo_mut(vcf_file,threehps_vcf,reads_depth,fw,child_num,parent1_num,parent2_num,denovo_file):
    highconf_locus,highconf_dict,highconf_dict2,highconf_parents_locus,highconf_parents_dict,highconf_parents_dict2 = find_highconf(threehps_vcf,reads_depth)
    lowconf_dict = find_lowconf(threehps_vcf)
    denovo_raw = get_denovo_raw_results(denovo_file)
    all_loci_dict = find_all_loci_3hps_vcf(threehps_vcf)

    print("highconf_locus #: " + str(len(highconf_locus)))
    print("highconf_parents_locus #: " + str(len(highconf_parents_locus)))
    f = open(vcf_file,"r")
    count_denovo = 0
    count_denovo2 = 0
    count_denovo_final = 0
    count = 0
    denovo_loci = []
    denovo_loci2 = []
    count_lowconf = 0
    for line in f:
        if line[:2] == "#C":
            data = line.rsplit()
            child_idx = data.index(child_num)
            parent1_idx = data.index(parent1_num)
            parent2_idx = data.index(parent2_num)
        elif line[0] != "#":
            data = line.rsplit()
            locus = int(data[1])
            chr_num = data[0]
            denovo_raw_flag = denovo_raw[(chr_num,str(locus))]
            lowconf = lowconf_dict[locus]
            highconf = highconf_dict2[locus]
            highconf_parents = highconf_parents_dict2[locus]

            child_GT = data[child_idx].split(":")[0]
            parent1_GT = data[parent1_idx].split(":")[0]
            parent2_GT = data[parent2_idx].split(":")[0]

            if (child_GT == "0|1" or child_GT == "0/1" or child_GT == "1|0" or child_GT == "1/0") and (parent1_GT == "0|0" or parent1_GT == "0/0") and (parent2_GT == "0|0" or parent2_GT == "0/0"):
                count += 1
                if highconf == 1 and denovo_raw_flag == 1:
                    denovo_loci.append(locus)
                    count_denovo += 1
                    if child_GT[1] == "|":
                        count_denovo_final += 1
                        fw.writelines(chr_num + "\t" + str(locus) + "\t" + child_GT + "\t" + parent1_GT + "\t" + parent2_GT + "\t" + str(1) + "\n")
                elif highconf == 0 and highconf_parents == 1:
                    denovo_loci2.append(locus)
                    count_denovo2 += 1
                elif lowconf == 1 and denovo_raw_flag == 1:
                    count_denovo_final += 1
                    count_lowconf += 1
                    fw.writelines(chr_num + "\t" + str(locus) + "\t" + child_GT + "\t" + parent1_GT + "\t" + parent2_GT + "\t" + str(0) + "\n")


    return count_lowconf




    
if __name__ == "__main__":
    if len(sys.argv) == 1:
        os.system("python HAPDeNovo.py -h")
    else:
        chr_start = args.chr_start
        chr_end = args.chr_end
        child_num = args.child_id
        parent1_num = args.parent1_id
        parent2_num = args.parent2_id
        out_dir = args.out_dir
        denovo_output_file = out_dir + args.output_file_prefix + ".txt"
        depth = args.depth
        denovo_file = args.input_file
        fw = open(denovo_output_file,"w")
        fw.writelines("Chr"+ "\t" + "Locus" + "\t" + "child_GT" + "\t" + "parents1_GT" + "\t" + "parents2_GT" + "\t" + "Confidence" + "\n")
        reads_depth = depth
        denovo_raw_file = denovo_file 
        print("depth = " + str(reads_depth))
        for chr_num in range(chr_start,chr_end+1): 
            phased_vcf = out_dir + "trio_mergecall_10x_phased_chr" + str(chr_num) + ".vcf" 
            threehps_vcf = out_dir + "hp_chr" + str(chr_num) + ".vcf"
            print("processing chr" + str(chr_num) + "..." )
            try:
                count_lowconf = find_denovo_mut(phased_vcf,threehps_vcf,reads_depth,fw, child_num, parent1_num, parent2_num,denovo_raw_file)
            except:
                print("no denovo for Chr" + str(chr_num))
        fw.close()


