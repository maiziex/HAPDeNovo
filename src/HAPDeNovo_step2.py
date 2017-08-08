import sys
import os

from argparse import ArgumentParser

parser = ArgumentParser(description="Step2 of HAPDeNovo")
parser.add_argument('--chr_start','-c_start',type=int,help="chromosome start from", default=1)
parser.add_argument('--chr_end','-c_end',type=int,help="chromosome end at", default=1)
parser.add_argument('--child_vcf','-c', help="Phased VCF file of child from Long Ranger")
parser.add_argument('--parent1_vcf','-p1', help="Phased VCF file of parent1 from Long Ranger")
parser.add_argument('--parent2_vcf','-p2', help="Phased VCF file of parent2 from Long Ranger")
parser.add_argument('--out_dir','-o_dir', help="Directory to store outputs", default='../HAPDeNovo_Results/')

args = parser.parse_args()

if __name__ == "__main__":
    if len(sys.argv) == 1:
        os.system("python HAPDeNovo_step2.py -h")
    else:
        used_command = "./Run_HAPDeNovo_step2.sh --child_vcf " + args.child_vcf + " --parent1_vcf " + args.parent1_vcf + " --parent2_vcf " + args.parent2_vcf + " --chr_start " + str(args.chr_start) + " --chr_end " + str(args.chr_end) + " --out_dir " + args.out_dir
        os.system("chmod +x *.sh")
        os.system(used_command)





