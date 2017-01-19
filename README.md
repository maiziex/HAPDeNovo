# HAPDeNovo: a haplotype based approach for filtering and phasing de novo mutations on linked-reads sequencing

HAPDeNovo is a software package to detect de novo mutations using read clouds sequencing data. 

## Download:
```
git clone https://github.com/HAPDeNovo/HAPDeNovo.git
```

## Dependencies:
Python3: https://www.python.org/downloads/  <br />
GATK: https://software.broadinstitute.org/gatk/download/   <br />
Freebayes: https://github.com/ekg/freebayes   <br />
Longranger: https://support.10xgenomics.com/genome-exome/software/downloads/latest  <br />
VCFtools: http://vcftools.sourceforge.net/ <br />
tabix: https://sourceforge.net/projects/samtools/files/tabix/   <br />
#### To be able to execute the above programs by typing their name on the command line, the program executables must be in one of the directories listed in the PATH environment variable.

## Running The Code:
### Step1:
```
./run_denovo_step1.sh --child NA12878 --child_id 20976 --child_sex female --child_bam NA12878_GRCh37.bam --parent1 NA12891 --parent1_id 20971 --parent1_sex male --parent1_bam NA12891_GRCh37.bam --parent2 NA12892 --parent2_id 20972 --parent2_sex female --parent2_bam NA12892_GRCh37.bam --output_vcf trio_merge.vcf --child_fastqs NA12878.fastqs --parent1_fastqs NA12891.fastqs --parent2_fastqs NA12892.fastqs  --reference refdata-hg19-2.1.0/fasta/genome.fa
```

--child: "NA12878" is the origin sample id of the child.  <br />
--child_id: "20976" is the sample id from the header of the bam file for child. <br />
--child_sex: "female" specifies the sex of the child. <br />
--child_bam: "NA12878_GRCh37.bam" is the bam file of the child. <br />
--parent1: "NA12891" is the origin sample id of the first parent.  <br />
--parent1_id: "20971" is the sample id from the header of the bam file for the first parent. <br />
--parent1_sex: "male" specifies the sex of the first parent. <br />
--parent1_bam: "NA12891_GRCh37.bam" is the bam file of the first parent. <br />
--parent2: "NA12892" is the origin sample id of the second parent.  <br />
--parent2_id: "20972" is the sample id from the header of the bam file for the second parent<br />
--parent2_sex: "female" specifies the sex of the second parent. <br />
--parent2_bam: "NA12892_GRCh37.bam" is the bam file of the second parent. <br />
--output_vcf: "trio_merge.vcf" is a user customized name of the multiple-sample variants called vcf file from the trio by freebayes/GATK.
<br />
--child_fastqs: "NA12878.fastqs" is the 10X fastqs file of the child.  <br />
--parent1_fastqs: "NA12891.fastqs" is the 10X fastqs file of the first parent.  <br />
--parent2_fastqs: "NA12892.fastqs" is the 10X fastqs file of the second parent.  <br />
--reference: "refdata-hg19-2.1.0/fasta/genome.fa" is the reference which can be download from https://support.10xgenomics.com/genome-exome/software/downloads/latest (or wget --no-check-certificate https://s3-us-west-2.amazonaws.com/10x.datasets/refdata-hg19-2.1.0.tar.gz).   <br />

#### Step 1 performs a multiple-sample variants call by freebayes/GATK. Multiple-sample called vcf file then is splitted into three single sample vcf files. The single sample vcf is further applied to Longranger as the precalled vcf to make the phased variants call. Alternatively, user can also use the following commands to finish this step. <br />
For GATK, more information can be found from https://software.broadinstitute.org/gatk/gatkdocs/org_broadinstitute_gatk_tools_walkers_haplotypecaller_HaplotypeCaller.php. 
<br />
```
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12878_GRCh37.bam -o child_gvcf -ERC GVCF  
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12891_GRCh37.bam -o parent1_gvcf -ERC GVCF  
java -jar GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12892_GRCh37.bam -o parent2_gvcf -ERC GVCF 
java -jar GenomeAnalysisTK.jar -T GenotypeGVCFs -R refdata-hg19-2.1.0/fasta/genome.fa -V child_gvcf -V parent1_gvcf -V parent2_gvcf -o trio_merge.vcf  
```

Or to generate trio_merge.vcf by using Freebayes, the command is as follows:
```
freebayes -f refdata-hg19-2.0.0/fasta/genome.fa NA12878_GRCh37.bam NA12891_GRCh37.bam NA12892_GRCh37.bam  > trio_merge.vcf  
```

To split the multiple-sample vcf file, VCFtools which can be download from http://vcftools.sourceforge.net/ can be used as follows: <br />
```
vcf-subset -c trio_merge.vcf
```

To run phased variants call, Longranger can be download from https://support.10xgenomics.com/genome-exome/software/downloads/latest, and all the precalled vcf files are generated from the previous step. <br />
```
longranger wgs --id=NA12878 --sex=female --fastqs=NA12878.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa --precalled=20976.vcf  
longranger wgs --id=NA12891 --sex=male --fastqs=NA12891.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa --precalled=20971.vcf  
longranger wgs --id=NA12892 --sex=female --fastqs=NA12892.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa --precalled=20972.vcf  
```

### Step 2:
```
./run_denovo_step2.sh --child_vcf NA12878_phased_variants.vcf.gz --parent1_vcf NA12891_phased_variants.vcf.gz --parent2_vcf NA12892_phased_variants.vcf.gz --chr_start 1 --chr_end 10 --output_prefix trio_mergecall_10x_phased
```

--child_vcf: "NA12878_phased_variants.vcf.gz" is the phased gzipped vcf file of the child generated by Longranger from step 1. <br />
--parent1_vcf: "NA12891_phased_variants.vcf.gz" is the phased gzipped vcf file of the first parent generated by Longranger from step 1. <br />
--parent2_vcf: "NA12892_phased_variants.vcf.gz" is the phased gzipped vcf file of the second parent generated by Longranger from step 1. <br />
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "10" specifies chromosome ending by 10.   <br />
--output_prefix: "trio_mergecall_10x_phased" is the user customized prefix of the vcf file for each chromosome.  <br />



### Step3:
```
./run_denovo_step3.sh --child NA12878 --parent1 NA12891 --parent2 NA12892 --child_id 20976 --child_hp1_id 20000 --child_hp2_id 20001 --child_nohp_id 20002 --parent1_id 20971 --parent1_hp1_id 20003 --parent1_hp2_id 20004 --parent1_nohp_id 20005 --parent2_id 20972 --parent2_hp1_id 20006 --parent2_hp2_id 20007 --parent2_nohp_id 20008 --child_bam NA12878_GRCh37.bam --parent1_bam NA12891_GRCh37.bam --parent2_bam NA12892_GRCh37.bam --reference refdata-hg19-2.1.0/fasta/genome.fa --chr_start 1 --chr_end 10
```

--child: "NA12878" is the origin sample id of the child.  <br />
--parent1: "NA12891" is the origin sample id of the first parent.  <br />
--parent2: "NA12892" is the origin sample id of the second parent.  <br />
--child_id: "20976" is the sample id from the header of the bam file for child.<br />
--child_hp1_id: "20000" is the user customized child id for the first haplotype.  <br />
--child_hp2_id" "20001" is the user customized child id for the second haplotype.  <br /> 
--child_nohp_id: "20002" is the user customized child id for the undefined haplotype. <br />
--parent1_id: "20971" is the sample id from the header of the bam file for the first parent. <br />
--parent1_hp1_id: "20003" is the user customized first parent id for the first haplotype.  <br />
--parent1_hp2_id: "20004" is the user customized first parent id for the second haplotype.  <br />
--parent1_nohp_id: "20005" is the user customized first parent id for the undefined haplotype.  <br /> 
--parent2_id: "20972" is the sample id from the header of the bam file for second parent. <br />
--parent2_hp1_id: "20006" is the user customized second parent id for the first haplotype.  <br />
--parent2_hp2_id: "20007" is the user customized second parent id for the second haplotype.  <br />
--parent2_nohp_id: "20008" is the user customized second parent id for the undefined haplotype.  <br /> 
--child_bam: "NA12878_GRCh37.bam" is the bam file of the child. <br />
--parent1_bam: "NA12891_GRCh37.bam" is the bam file of the first parent. <br />
--parent2_bam: "NA12892_GRCh37.bam" is the bam file of the second parent. <br />
--reference: "refdata-hg19-2.1.0/fasta/genome.fa" is the reference as before. <br />
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "10" specifies chromosome ending by 10.   <br />


### Run HAPDeNovo
```
python3 HAPDeNovo.py --chr_start 1 --chr_end 10 --child_id 20976 --parent1_id 20971 --parent2_id 20972 --phased_vcf_prefix trio_mergecall_10x_phased --output denovo_triodenovo_depth15_HAPDeNovo_filer1.txt --depth 1 --input_denovo denovo_triodenovo_depth15_DQ7.txt --input_file_dir ../doc
```
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "10" specifies chromosome ending by 10.   <br />
--child_id: "20976" is the sample id from the header of the bam file for child.  <br />
--parent1_id: "20971" is the sample id from the header of the bam file for first parent. <br />
--parent2_id: "20972" is the sample id from the header of the bam file for second parent.  <br />
--phased_vcf_prefix: "trio_mergecall_10x_phased" is the user customized prefix of the vcf file for each chromosome from step 2.  <br />
--output: "denovo_triodenovo_depth15_HAPDeNovo_filer1.txt" is the user customized txt file name for final de novo mutation output. <br />
--depth: "1" specifies the depth filter by 1. <br />
--input_denovo: "denovo_triodenovo_depth15_DQ7.txt" is the de novo results from other tools like GATK/freebayes/TrioDenovo/DeNovoGear, or any user customized txt file for de novo muations. This text file needs to contain chromose name and the corresponding locus per row for each de novo mutation. <br />
--input_file_dir: "../doc" specifies the directory folder for the input_denovo file.  <br />



