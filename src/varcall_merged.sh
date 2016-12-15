set -x
sample1_name=$1
sample2_name=$2
sample3_name=$3

bam_1=$4
bam_2=$5
bam_3=$6
reference=$7

output_gvcf1=$sample1_name".g.vcf"
output_gvcf2=$sample2_name".g.vcf"
output_gvcf3=$sample3_name".g.vcf"

vcf_output=$8
echo "generating "$output_gvcf1" using GATK haplotyper"
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $bam_1 -o $output_gvcf1 -ERC GVCF
echo "generating "$output_gvcf2" using GATK haplotyper"
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $bam_2 -o $output_gvcf2 -ERC GVCF
echo "generating "$output_gvcf3" using GATK haplotyper"
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $bam_3 -o $output_gvcf3 -ERC GVCF

java -jar GenomeAnalysisTK.jar -T GenotypeGVCFs -R $reference -V $output_gvcf1 -V $output_gvcf2 -V $output_gvcf3 -o $vcf_output

