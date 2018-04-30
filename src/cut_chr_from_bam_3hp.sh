#set -x
sample_name=$2
sample_num=$4
sample_num_hp1=$6
sample_num_hp2=$8
sample_num_nohp=${10}
input_bam=${12}
reference=${14}
chr_num=${16}
out_dir=${18}

for i in `eval echo {$chr_num..$chr_num}`
do
    chr="chr"
    chr_num=$chr$i
    chromosomeX=23
    if [ $i -eq $chromosomeX ]
    then
        echo $i
        chr_num="chrX"
        echo $chr_num
    fi

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
    samtools view -b $input_bam $chr_num > $out_dir$output

    echo "extracting hp1 to get "$output_hp1
    echo "extract hp1 to get "$output_hp1
    samtools view $out_dir$output  | grep "HP:i:1" | sed 's/'${sample_num}'/'${sample_num_hp1}'/g' | samtools view -bt $reference".fai" > $out_dir$output_hp1
    echo "extract hp2 to get "$output_hp2
    samtools view $out_dir$output  | grep "HP:i:2" | sed 's/'${sample_num}'/'${sample_num_hp2}'/g' | samtools view -bt $reference".fai" > $out_dir$output_hp2
    echo "extract nohp to get "$output_nohp
    samtools view $out_dir$output  | grep -v "HP" | sed 's/'${sample_num}'/'${sample_num_nohp}'/g' | samtools view -bt $reference".fai" > $out_dir$output_nohp

    echo "extracting header.."
    samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_hp1}'/g' > $out_dir$header1
    samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_hp2}'/g' > $out_dir$header2
    samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_nohp}'/g' > $out_dir$header3
    
    echo "reheadering..."
    samtools reheader $out_dir$header1 $out_dir$output_hp1 > $out_dir$output_hp1_withheader
    samtools reheader $out_dir$header2 $out_dir$output_hp2 > $out_dir$output_hp2_withheader
    samtools reheader $out_dir$header3 $out_dir$output_nohp > $out_dir$output_nohp_withheader 

    echo "sorting bam..."
    samtools sort $out_dir$output_hp1_withheader -o $out_dir$output_hp1_sort
    samtools sort $out_dir$output_hp2_withheader -o $out_dir$output_hp2_sort
    samtools sort $out_dir$output_nohp_withheader -o $out_dir$output_nohp_sort
   
    echo "indexing bam..."
    samtools index $out_dir$output_hp1_sort
    samtools index $out_dir$output_hp2_sort
    samtools index $out_dir$output_nohp_sort

    rm $out_dir$output_hp1
    rm $out_dir$output_hp1_withheader
    rm $out_dir$output_hp2
    rm $out_dir$output_hp2_withheader
    rm $out_dir$output_nohp
    rm $out_dir$output_nohp_withheader
    rm $out_dir$header1
    rm $out_dir$header2
    rm $out_dir$header3

    echo "generate GVCF using GATK haplotypecaller..."
    java -jar /oak/stanford/groups/arend/Xin/SimProj/10X/For_reviewers_BMC_Genomics/HAPDeNovo/lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $out_dir$output_hp1_sort -o $out_dir$output_gvcf1 -ERC GVCF
    java -jar /oak/stanford/groups/arend/Xin/SimProj/10X/For_reviewers_BMC_Genomics/HAPDeNovo/lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $out_dir$output_hp2_sort -o $out_dir$output_gvcf2 -ERC GVCF
    java -jar /oak/stanford/groups/arend/Xin/SimProj/10X/For_reviewers_BMC_Genomics/HAPDeNovo/lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $out_dir$output_nohp_sort -o $out_dir$output_gvcf3 -ERC GVCF

    rm $out_dir$output_hp1_sort
    rm $out_dir$output_hp1_sort".bai"
    rm $out_dir$output_hp2_sort
    rm $out_dir$output_hp2_sort".bai"
    rm $out_dir$output_nohp_sort
    rm $out_dir$output_nohp_sort".bai"
    rm $out_dir$output
 
 


done
