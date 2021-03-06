set -x
sample_name=$2
sample_num=$4
sample_num_hp1=$6
sample_num_hp2=$8
sample_num_nohp=${10}
input_bam=${12}
reference=${14}
chr_num=${16}
out_dir=${18}
child_sex=${20}

for i in `eval echo {$chr_num..$chr_num}`
do
    chr="chr"
    chr_num=$chr$i
    chromosomeX=23
    daughter_sex="female"
    son_sex="male"
    child_sample_id="20000"
    father_sample_id="20003"
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
    ../lib/samtools/samtools view -b $input_bam $chr_num > $out_dir$output

    if ([ "$child_sex" == "$daughter_sex" ] && [ $sample_num_hp1 -eq $father_sample_id ] && [ $i -eq $chromosomeX ])
    then
        echo "using child_sex: female"
        python3 Re_Haplotyping_bam_paternal.py --input_file $out_dir$output
        echo "finishing Re_haplotyping..."
    fi
    if ([ "$child_sex" == "$son_sex" ] && [ $sample_num_hp1 -eq $child_sample_id ] && [ $i -eq $chromosomeX ])
    then
        echo "using child_sex: male"
        python3 Re_Haplotyping_bam_paternal.py --input_file $out_dir$output
        echo "finishing Re_haplotyping..."
    fi
    echo $child_sex
    echo $daughter_sex
    echo [ $child_sex -eq $daughter_sex ]
    echo $sample_num_hp1
    echo $child_sample_id
    echo $father_sample_id
    echo [ $sample_num_hp1 -eq $father_sample_id]
    echo $i
    echo $chromosomeX
    echo [ $i -eq $chromosomeX ]
    echo "extract hp1 to get "$output_hp1
    ../lib/samtools/samtools view $out_dir$output  | grep "HP:i:1" | sed 's/'${sample_num}'/'${sample_num_hp1}'/g' | ../lib/samtools/samtools view -bt $reference".fai" > $out_dir$output_hp1
    echo "extract hp2 to get "$output_hp2
    ../lib/samtools/samtools view $out_dir$output  | grep "HP:i:2" | sed 's/'${sample_num}'/'${sample_num_hp2}'/g' | ../lib/samtools/samtools view -bt $reference".fai" > $out_dir$output_hp2
    echo "extract nohp to get "$output_nohp
    ../lib/samtools/samtools view $out_dir$output  | grep -v "HP" | sed 's/'${sample_num}'/'${sample_num_nohp}'/g' | ../lib/samtools/samtools view -bt $reference".fai" > $out_dir$output_nohp

    echo "extracting header.."
    ../lib/samtools/samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_hp1}'/g' > $out_dir$header1
    ../lib/samtools/samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_hp2}'/g' > $out_dir$header2
    ../lib/samtools/samtools view -H $input_bam  | sed 's/'${sample_num}'/'${sample_num_nohp}'/g' > $out_dir$header3
    
    echo "reheadering..."
    ../lib/samtools/samtools reheader $out_dir$header1 $out_dir$output_hp1 > $out_dir$output_hp1_withheader
    ../lib/samtools/samtools reheader $out_dir$header2 $out_dir$output_hp2 > $out_dir$output_hp2_withheader
    ../lib/samtools/samtools reheader $out_dir$header3 $out_dir$output_nohp > $out_dir$output_nohp_withheader 

    echo "sorting bam..."
    ../lib/samtools/samtools sort $out_dir$output_hp1_withheader -o $out_dir$output_hp1_sort
    ../lib/samtools/samtools sort $out_dir$output_hp2_withheader -o $out_dir$output_hp2_sort
    ../lib/samtools/samtools sort $out_dir$output_nohp_withheader -o $out_dir$output_nohp_sort
   
    echo "indexing bam..."
    ../lib/samtools/samtools index $out_dir$output_hp1_sort
    ../lib/samtools/samtools index $out_dir$output_hp2_sort
    ../lib/samtools/samtools index $out_dir$output_nohp_sort

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
    java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $out_dir$output_hp1_sort -o $out_dir$output_gvcf1 -ERC GVCF
    java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $out_dir$output_hp2_sort -o $out_dir$output_gvcf2 -ERC GVCF
    java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $reference -I $out_dir$output_nohp_sort -o $out_dir$output_gvcf3 -ERC GVCF

    rm $out_dir$output_hp1_sort
    rm $out_dir$output_hp1_sort".bai"
    rm $out_dir$output_hp2_sort
    rm $out_dir$output_hp2_sort".bai"
    rm $out_dir$output_nohp_sort
    rm $out_dir$output_nohp_sort".bai"
    rm $out_dir$output
 
 


done
