import sys
import os

from argparse import ArgumentParser

parser = ArgumentParser(description="Step3 of HAPDeNovo:")
parser.add_argument('--chr_start','-c_start',type=int,help="Chromosome start from", default=1)
parser.add_argument('--chr_end','-c_end',type=int,help="Chromosome end at", default=1)
parser.add_argument('--child','-c', help="The origin sample id of the child, for example: NA12878")
parser.add_argument('--parent1','-p1', help="The origin sample id of parent1, for example: NA12891")
parser.add_argument('--parent2','-p2', help="The origin sample id of parent2, for example: NA12892")
parser.add_argument('--child_id','-c_id', help="The sample id from the header of the bam file for child, for example: 20976")
parser.add_argument('--parent1_id','-p1_id', help="The sample id from the header of the bam file for parent1, for example: 20971 ")
parser.add_argument('--parent2_id','-p2_id', help="The sample id from the header of the bam file for parent2, for example: 20972")
parser.add_argument('--child_bam', help="The bam file of the child")
parser.add_argument('--parent1_bam', help="The bam file of parent1")
parser.add_argument('--parent2_bam', help="The bam file of parent2")
parser.add_argument('--reference','-r', help="The reference fasta file")
parser.add_argument('--child_sex','-s', help="The child sex, for example, male or female")
parser.add_argument('--out_dir','-o_dir', help="Directory to store outputs", default='../HAPDeNovo_Results/')

args = parser.parse_args()

if __name__ == "__main__":
    if len(sys.argv) == 1:
        os.system("python HAPDeNovo_step3.py -h")
    else:
        used_command = "./Run_HAPDeNovo_step3.sh --child " + args.child + " --parent1 " + args.parent1 + " --parent2 " + args.parent2 + " --child_id "+ args.child_id +  " --parent1_id " + args.parent1_id + " --parent2_id " + args.parent2_id + " --child_bam "+ args.child_bam +  " --parent1_bam " + args.parent1_bam + " --parent2_bam " + args.parent2_bam + " --reference " + args.reference +  " --chr_start " + str(args.chr_start) + " --chr_end " + str(args.chr_end) + " --out_dir " + args.out_dir + " --child_sex " + str(args.child_sex)
        os.system(used_command)





