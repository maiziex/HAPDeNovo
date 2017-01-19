# HAPDeNovo

# step1:
./run_denovo_step1.sh --child NA12878 --child_id 20976 --child_sex female --child_bam NA12878_GRCh37.bam --parent1 NA12891 --parent1_id 20971 --parent1_sex male --parent1_bam NA12891_GRCh37.bam --parent2 NA12892 --parent2_id 20972 --parent2_sex female --parent2_bam NA12892_GRCh37.bam --output_vcf trio_merge.vcf --child_fastqs NA12878.fastqs --parent1_fastqs NA12891.fastqs --parent2_fastqs NA12892.fastqs  --reference refdata-hg19-2.1.0/fasta/genome.fa


--child: "NA12878" is the origin sample id of the child.  <br />
--child_id: "20976"  <br />
--child_sex: "female" specifies the sex of the child. <br />
--child_bam: "NA12878_GRCh37.bam" is the bam file of the child. <br />
--parent1: "NA12891" is the origin sample id of the first parent.  <br />
--parent1_id: "20971" <br />
--parent1_sex: "male" specifies the sex of the first parent. <br />
--parent1_bam: "NA12891_GRCh37.bam" is the bam file of the first parent. <br />
--parent2: "NA12892" is the origin sample id of the second parent.  <br />
--parent2_id: "20972" <br />
--parent2_sex: "female" specifies the sex of the second parent. <br />
--parent2_bam: "NA12892_GRCh37.bam" is the bam file of the second parent. <br />
--output_vcf: "trio_merge.vcf" is name of the multiple-sample variants called vcf file from the trio by freebayes/GATK. User can specifiy this name.
<br />
--child_fastqs: "NA12878.fastqs" is the 10X fastqs file of the child.  <br />
--parent1_fastqs: "NA12891.fastqs" is the 10X fastqs file of the first parent.  <br />
--parent2_fastqs: "NA12892.fastqs" is the 10X fastqs file of the second parent.  <br />
--reference: "refdata-hg19-2.1.0/fasta/genome.fa" is the reference which can be download from https://support.10xgenomics.com/genome-exome/software/downloads/latest (or wget --no-check-certificate https://s3-us-west-2.amazonaws.com/10x.datasets/refdata-hg19-2.1.0.tar.gz).   <br />

The first step performs a multiple-sample variants call by freebayes/GATK. User can also use the following commands to finish it. More information can be found from https://software.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_gatk_tools_walkers_haplotypecaller_HaplotypeCaller.php. 
<br />
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12878_GRCh37.bam -o child_gvcf -ERC GVCF  <br />
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12891_GRCh37.bam -o parent1_gvcf -ERC GVCF  <br />
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12892_GRCh37.bam -o parent2_gvcf -ERC GVCF  <br />
java -jar GenomeAnalysisTK.jar -T GenotypeGVCFs -R refdata-hg19-2.1.0/fasta/genome.fa -V child_gvcf -V parent1_gvcf -V parent2_gvcf -o trio_merge.vcf  <br />





# step 2:
./run_denovo_step2.sh --child_vcf NA12878_phased_variants.vcf.gz --parent1_vcf NA12891_phased_variants.vcf.gz --parent2_vcf NA12892_phased_variants.vcf.gz --chr_start 1 --chr_end 1 --output_prefix trio_mergecall_10x_phased


# step3:
./run_denovo_step3.sh --child NA12878 --parent1 NA12891 --parent2 NA12892 --child_id 20976 --child_hp1_id 20000 --child_hp2_id 20001 --child_nohp_id 20002 --parent1_id 20971 --parent1_hp1_id 20003 --parent1_hp2_id 20004 --parent1_nohp_id 20005 --parent2_id 20972 --parent2_hp1_id 20006 --parent2_hp2_id 20007 --parent2_nohp_id 20008 --child_bam NA12878_GRCh37.bam --parent1_bam NA12891_GRCh37.bam --parent2_bam NA12892_GRCh37.bam --reference refdata-hg19-2.1.0/fasta/genome.fa --chr_start 1 --chr_end 1


# Use HAPDeNovo
python3 HAPDeNovo.py --chr_start 15 --chr_end 15 --child_id 20976 --parent1_id 20971 --parent2_id 20972 --phased_vcf_prefix trio_mergecall_10x_phased --output denovo_triodenovo_depth15_HAPDeNovo_filer1.txt --depth 1 --input_denovo denovo_triodenovo_depth15_DQ7.txt --input_file_dir ../doc

