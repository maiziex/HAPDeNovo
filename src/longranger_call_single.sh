set -x
sample_name=$1
sample_sex=$2
sample_num=$3
merged_vcf=$4
sample_fastqs=$5
reference=$6
output=$sample_num".vcf"
echo "using "$merged_vcf
#vcf-subset -c $sample_num $merged_vcf > $output
vcf-subset -c $merged_vcf 

longranger wgs --id=$sample_name --sex=$sample_sex --fastqs=$sample_fastqs --reference=$reference --precalled=$output
