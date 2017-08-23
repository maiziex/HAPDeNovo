set -x
sample1_name=$2
sample2_name=$4
sample3_name=$6
reference=${8}
chr_num=${10}
out_dir=${12}
out_file_prefix=${14}


##### Step 3: split origin bam file to three different type for hp1, hp2, nohp, then use GATK to do variants call

java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $reference -V "$out_dir""$sample1_name"_chr"$chr_num"_hp1.g.vcf -V "$out_dir""$sample1_name"_chr"$chr_num"_hp2.g.vcf -V "$out_dir""$sample1_name"_chr"$chr_num"_nohp.g.vcf -V "$out_dir""$sample2_name"_chr"$chr_num"_hp1.g.vcf -V "$out_dir""$sample2_name"_chr"$chr_num"_hp2.g.vcf -V "$out_dir""$sample2_name"_chr"$chr_num"_nohp.g.vcf -V "$out_dir""$sample3_name"_chr"$chr_num"_hp1.g.vcf -V "$out_dir""$sample3_name"_chr"$chr_num"_hp2.g.vcf -V "$out_dir""$sample3_name"_chr"$chr_num"_nohp.g.vcf -o "$out_dir""$out_file_prefix"_chr"$chr_num".vcf

rm "$out_dir""$sample1_name"_chr"$chr_num"_hp1.g.vcf*
rm "$out_dir""$sample1_name"_chr"$chr_num"_hp2.g.vcf*
rm "$out_dir""$sample1_name"_chr"$chr_num"_nohp.g.vcf*
rm "$out_dir""$sample2_name"_chr"$chr_num"_hp1.g.vcf*
rm "$out_dir""$sample2_name"_chr"$chr_num"_hp2.g.vcf*
rm "$out_dir""$sample2_name"_chr"$chr_num"_nohp.g.vcf*
rm "$out_dir""$sample3_name"_chr"$chr_num"_hp1.g.vcf*
rm "$out_dir""$sample3_name"_chr"$chr_num"_hp2.g.vcf*
rm "$out_dir""$sample3_name"_chr"$chr_num"_nohp.g.vcf*

