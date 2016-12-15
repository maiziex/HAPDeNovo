set -x
sample1_name=$2
sample1_num=$4
sample1_sex=$6
sample1_bam=$8
sample2_name=${10}
sample2_num=${12}
sample2_sex=${14}
sample2_bam=${16}
sample3_name=${18}
sample3_num=${20}
sample3_sex=${22}
sample3_bam=${24}
trio_vcf=${26}
sample1_fastqs=${28}
sample2_fastqs=${30}
sample3_fastqs=${32}
reference=${34}


##### Step 1_1: GATK multiple samples call variants, then split to single vcf
./varcall_merged.sh $sample1_name $sample2_name $sample3_name $sample1_bam $sample2_bam $sample3_bam $reference $trio_vcf
##### Step 1_2: longranger variant call for single vcf to phase vcf, then merge them to one vcf
./longranger_call_single.sh $sample1_name $sample1_sex $sample1_num $trio_vcf $sample1_fastqs $reference 
./longranger_call_single.sh $sample2_name $sample2_sex $sample2_num $trio_vcf $sample2_fastqs $reference 
./longranger_call_single.sh $sample3_name $sample3_sex $sample3_num $trio_vcf $sample3_fastqs $reference 

