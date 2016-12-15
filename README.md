# HAPDeNovo

# step1:
./run_denovo_step1.sh --child NA12878 --child_id 20976 --child_sex female --child_bam NA12878_GRCh37.bam --parent1 NA12891 --parent1_id 20971 --parent1_sex male --parent1_bam NA12891_GRCh37.bam --parent2 NA12892 --parent2_id 20972 --parent2_sex female --parent2_bam NA12892_GRCh37.bam --vcf trio_merge.vcf --child_fastqs NA12878.fastqs --parent1_fastqs NA12891.fastqs --parent2_fastqs NA12892.fastqs  --reference refdata-hg19-2.1.0/fasta/genome.fa

# step 2:
./run_denovo_step2.sh --child_vcf NA12878_phased_variants.vcf.gz --parent1_vcf NA12891_phased_variants.vcf.gz --parent2_vcf NA12892_phased_variants.vcf.gz --chr_start 1 --chr_end 1 --output_prefix trio_mergecall_10x_phased

# step3:
./run_denovo_step3.sh --child NA12878 --parent1 NA12891 --parent2 NA12892 --child_id 20976 --child_hp1_id 20000 --child_hp2_id 20001 --child_nohp_id 20002 --parent1_id 20971 --parent1_hp1_id 20003 --parent1_hp2_id 20004 --parent1_nohp_id 20005 --parent2_id 20972 --parent2_hp1_id 20006 --parent2_hp2_id 20007 --parent2_nohp_id 20008 --child_bam NA12878_GRCh37.bam --parent1_bam NA12891_GRCh37.bam --parent2_bam NA12892_GRCh37.bam --reference refdata-hg19-2.1.0/fasta/genome.fa --chr_start 1 --chr_end 1


# Use HAPDeNovo
python3 HAPDeNovo.py --chr_start 15 --chr_end 15 --child_id 20976 --parent1_id 20971 --parent2_id 20972 --phased_vcf_prefix trio_mergecall_10x_phased --output denovo_triodenovo_depth15_HAPDeNovo_filer1.txt --depth 1 --input_denovo denovo_triodenovo_depth15_DQ7.txt --input_file_dir ../doc

