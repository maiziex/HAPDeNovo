set -x
sample_name=$1
input_bam=$2
sample_num=${3}
sample_num_hp1=${4}
sample_num_hp2=${5}
sample_num_nohp=${6}
reference=$7
chr_start=$8
chr_end=$9

for i in `eval echo {$chr_start..$chr_end}`
do
    chr="chr"
    chr_num=$chr$i
    echo "processing "$chr_num
    output_suffix=".bam"
    output=$sample_name"_"$chr$i$output_suffix

    output_hp1=$sample_name"_"$chr$i"_hp1"$output_suffix
    output_hp2=$sample_name"_"$chr$i"_hp2"$output_suffix
    output_nohp=$sample_name"_"$chr$i"_nohp"$output_suffix

    header1=$sample_name"_"$chr$i"_hp1""_header.sam"
    header2=$sample_name"_"$chr$i"_hp2""_header.sam"
    header3=$sample_name"_"$chr$i"_nohp""_header.sam"
    
    output_hp1_withheader=$sample_name"_"$chr$i"_hp1_withheader"$output_suffix
    output_hp2_withheader=$sample_name"_"$chr$i"_hp2_withheader"$output_suffix
    output_nohp_withheader=$sample_name"_"$chr$i"_nohp_withheader"$output_suffix


    output_hp1_sort=$sample_name"_"$chr$i"_hp1_sorted"$output_suffix
    output_hp2_sort=$sample_name"_"$chr$i"_hp2_sorted"$output_suffix
    output_nohp_sort=$sample_name"_"$chr$i"_nohp_sorted"$output_suffix

    output_gvcf1=$sample_name"_"$chr$i"_hp1.g.vcf"
    output_gvcf2=$sample_name"_"$chr$i"_hp2.g.vcf"
    output_gvcf3=$sample_name"_"$chr$i"_nohp.g.vcf"
 
    
    echo "generating "$output
    samtools view -b $input_bam $chr_num > $output

    echo "extracting hp1 to get "$output_hp1
    echo "extract hp1 to get "$output_hp1
    samtools view $output  | grep "HP:i:1" | sed 's/'${sample_num}'/'${sample_num_hp1}'/g' | samtools view -bt $reference".fai" > $output_hp1
    echo "extract hp2 to get "$output_hp2
    samtools view $output  | grep "HP:i:2" | sed 's/'${sample_num}'/'${sample_num_hp2}'/g' | samtools view -bt $reference".fai" > $output_hp2
    echo "extract nohp to get "$output_nohp
    samtools view $output  | grep -v "HP" | sed 's/'${sample_num}'/'${sample_num_nohp}'/g' | samtools view -bt $reference".fai" > $output_nohp

    echo "extracting header.."
    samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_hp1}'/g' > $header1
    samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_hp2}'/g' > $header2
    samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_nohp}'/g' > $header3
    
    echo "reheadering..."
    samtools reheader $header1 $output_hp1 > $output_hp1_withheader
    samtools reheader $header2 $output_hp2 > $output_hp2_withheader
    samtools reheader $header3 $output_nohp > $output_nohp_withheader 

    echo "sorting bam..."
    samtools sort $output_hp1_withheader -o $output_hp1_sort
    samtools sort $output_hp2_withheader -o $output_hp2_sort
    samtools sort $output_nohp_withheader -o $output_nohp_sort
   
    echo "indexing bam..."
    samtools index $output_hp1_sort
    samtools index $output_hp2_sort
    samtools index $output_nohp_sort

    rm $output_hp1
    rm $output_hp1_withheader
    rm $output_hp2
    rm $output_hp2_withheader
    rm $output_nohp
    rm $output_nohp_withheader
    rm $header1
    rm $header2
    rm $header3

    echo "generate GVCF using GATK haplotypecaller..."
    java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $output_hp1_sort -o $output_gvcf1 -ERC GVCF
    java -jar GenomeAnalysisTK-3.6/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $output_hp2_sort -o $output_gvcf2 -ERC GVCF
    java -jar GenomeAnalysisTK-3.6/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $output_nohp_sort -o $output_gvcf3 -ERC GVCF

done
