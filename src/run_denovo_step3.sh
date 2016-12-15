set -x
sample1_name=$2
sample2_name=$4
sample3_name=$6
sample1_num=$8
sample1_hp1_num=${10}
sample1_hp2_num=${12}
sample1_nohp_num=${14}
sample2_num=${16}
sample2_hp1_num=${18}
sample2_hp2_num=${20}
sample2_nohp_num=${22}
sample3_num=${24}
sample3_hp1_num=${26}
sample3_hp2_num=${28}
sample3_nohp_num=${30}
sample1_bam=${32}
sample2_bam=${34}
sample3_bam=${36}
reference=${38}
chr_start=${40}
chr_end=${42}


##### Step 3: split origin bam file to three different type for hp1, hp2, nohp, then use GATK to do variants call
echo "running Step 4..."
echo "chr_start="$chr_start" , chr_end="$chr_end
./cut_chr_from_bam.sh $sample1_name $sample1_bam $sample1_num $sample1_hp1_num $sample1_hp2_num $sample1_nohp_num $reference $chr_start $chr_end
./cut_chr_from_bam.sh $sample2_name $sample2_bam $sample2_num $sample2_hp1_num $sample2_hp2_num $sample2_nohp_num $reference $chr_start $chr_end
./cut_chr_from_bam.sh $sample3_name $sample3_bam $sample3_num $sample3_hp1_num $sample3_hp2_num $sample3_nohp_num $reference $chr_start $chr_end

for i in `eval echo {$chr_start..$chr_end}`
do
    java -jar /scail/u/xzhou15/Softwares/GenomeAnalysisTK-3.6/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $reference -V "$sample1_name"_chr"$i"_hp1.g.vcf -V "$sample1_name"_chr"$i"_hp2.g.vcf -V "$sample1_name"_chr"$i"_nohp.g.vcf -V "$sample2_name"_chr"$i"_hp1.g.vcf -V "$sample2_name"_chr"$i"_hp2.g.vcf -V "$sample2_name"_chr"$i"_nohp.g.vcf -V "$sample3_name"_chr"$i"_hp1.g.vcf -V "$sample3_name"_chr"$i"_hp2.g.vcf -V "$sample3_name"_chr"$i"_nohp.g.vcf  -o chr"$i".vcf
done

rm "$sample1_name"_chr"$i"_hp1.g.vcf
rm "$sample1_name"_chr"$i"_hp2.g.vcf
rm "$sample1_name"_chr"$i"_nohp.g.vcf
rm "$sample2_name"_chr"$i"_hp1.g.vcf
rm "$sample2_name"_chr"$i"_hp2.g.vcf
rm "$sample2_name"_chr"$i"_nohp.g.vcf
rm "$sample3_name"_chr"$i"_hp1.g.vcf
rm "$sample3_name"_chr"$i"_hp2.g.vcf
rm "$sample3_name"_chr"$i"_nohp.g.vcf

