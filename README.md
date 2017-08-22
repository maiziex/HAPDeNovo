# HAPDeNovo: a haplotype based approach for filtering and phasing de novo mutations on barcoded read-cloud sequencing

HAPDeNovo is a software package to detect de novo mutations on barcoded read-cloud sequencing. 

## Download:
```
git clone https://github.com/HAPDeNovo/HAPDeNovo.git
```
## Install:
```
cd HAPDeNovo
chmod +x install.sh
./install.sh
```

## Running The Code, the working directory is "src":
### Step 1:
To download referece files, go to <a href="https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest">10X GENOMICS Website</a>, or
```
wget http://cf.10xgenomics.com/supp/genome/refdata-hg19-2.1.0.tar.gz
```
To get bam files, phased variants vcf files: 
```
../lib/longranger/longranger wgs --id=NA12878 --sex=female --fastqs=NA12878.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa 
../lib/longranger/longranger wgs --id=NA12891 --sex=male --fastqs=NA12891.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa  
../lib/longranger/longranger wgs --id=NA12892 --sex=female --fastqs=NA12892.fastqs --reference=refdata-hg19-2.1.0/fasta/genome.fa   
```
Performs a multiple-sample variants call by freebayes or GATK. Multiple-sample called vcf file then is splitted into three single sample vcf files.   <br />
For GATK, more information can be found from <a href="https://software.broadinstitute.org/gatk/documentation/tooldocs/current/org_broadinstitute_gatk_tools_walkers_haplotypecaller_HaplotypeCaller.php">here</a>. 
<br />
```
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12878_GRCh37.bam -o child_gvcf -ERC GVCF  
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12891_GRCh37.bam -o parent1_gvcf -ERC GVCF  
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T HaplotypeCaller -R refdata-hg19-2.1.0/fasta/genome.fa -I NA12892_GRCh37.bam -o parent2_gvcf -ERC GVCF 
java -jar ../lib/GenomeAnalysisTK/GenomeAnalysisTK.jar -T GenotypeGVCFs -R refdata-hg19-2.1.0/fasta/genome.fa -V child_gvcf -V parent1_gvcf -V parent2_gvcf -o trio_merge.vcf  
```

Or to generate trio_merge.vcf by using Freebayes:
```
../lib/freebayes/bin/freebayes -f refdata-hg19-2.0.0/fasta/genome.fa NA12878_GRCh37.bam NA12891_GRCh37.bam NA12892_GRCh37.bam  > trio_merge.vcf  
```

To split the multiple-sample vcf file: <br />
```
../lib/vcftools/src/perl/vcf-subset -c trio_merge.vcf
```



### Step 2: (Type "python HAPDeNovo_step2.py -h" for help information)
```
python3 HAPDeNovo_step2.py --child_vcf ../output/NA12878_phased_variants.vcf.gz --parent1_vcf ../output/NA12891_phased_variants.vcf.gz --parent2_vcf ../output/NA12892_phased_variants.vcf.gz --chr_start 1 --chr_end 2 --out_dir ../output/
```

--child_vcf: "NA12878_phased_variants.vcf.gz" is the phased gzipped vcf file of the child generated by Longranger from step 1. <br />
--parent1_vcf: "NA12891_phased_variants.vcf.gz" is the phased gzipped vcf file of the first parent generated by Longranger from step 1. <br />
--parent2_vcf: "NA12892_phased_variants.vcf.gz" is the phased gzipped vcf file of the second parent generated by Longranger from step 1. <br />
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "2" specifies chromosome ending by 2.   <br />
--out_dir: "../output/" specifies the customized folder name for output results. <br />



### Step3: ((Type "python HAPDeNovo_step3.py -h" for help information))
```
python3 HAPDeNovo_step3.py --child NA12878 --parent1 NA12891 --parent2 NA12892 --child_id 20976 --parent1_id 20971 --parent2_id 20972 --child_bam ../output/NA12878_GRCh37.bam --parent1_bam ../output/NA12891_GRCh37.bam --parent2_bam ../output/NA12892_GRCh37.bam --reference refdata-hg19-2.1.0/fasta/genome.fa --chr_start 1 --chr_end 2 --out_dir ../output/
```

--child: "NA12878" is the origin sample id of the child.  <br />
--parent1: "NA12891" is the origin sample id of the first parent.  <br />
--parent2: "NA12892" is the origin sample id of the second parent.  <br />
--child_id: "20976" is the sample id from the header of the bam file for child.<br />
--parent1_id: "20971" is the sample id from the header of the bam file for the first parent. <br />
--parent2_id: "20972" is the sample id from the header of the bam file for second parent. <br />
--child_bam: "NA12878_GRCh37.bam" is the bam file of the child. <br />
--parent1_bam: "NA12891_GRCh37.bam" is the bam file of the first parent. <br />
--parent2_bam: "NA12892_GRCh37.bam" is the bam file of the second parent. <br />
--reference: "refdata-hg19-2.1.0/fasta/genome.fa" is the reference as before. <br />
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "2" specifies chromosome ending by 2.   <br />
--out_dir: "../output/" specifies the customized folder name for output results. <br />


### Run HAPDeNovo_final.py: (Type "python HAPDeNovo_final.py -h" for help information)

```
python3 HAPDeNovo_final.py --chr_start 1 --chr_end 22 --child_id 20976 --parent1_id 20971 --parent2_id 20972 --out_dir ../output/ --output_file_prefix denovo_triodenovo_depth15_HAPDeNovo_filer1 --depth 1 --input_file ../doc/denovo_triodenovo_depth15_DQ7.txt
```
--chr_start: "1" specifies chromosome starting from 1.  <br />
--chr_end: "22" specifies chromosome ending by 22.   <br />
--child_id: "20976" is the sample id from the header of the bam file for child.  <br />
--parent1_id: "20971" is the sample id from the header of the bam file for first parent. <br />
--parent2_id: "20972" is the sample id from the header of the bam file for second parent.  <br />
--out_dir: "../output/" specifies the customized folder name for output results. <br />
--output_file_prefix: "denovo_triodenovo_depth15_HAPDeNovo_filer1" is the user customized file name for final de novo mutation output. <br />
--depth: "1" specifies the depth filter by 1. <br />
--input_file: "denovo_triodenovo_depth15_DQ7.txt" is the de novo results from other tools like GATK/freebayes/TrioDenovo/DeNovoGear, or any user customized txt file for de novo muations. This text file needs to contain chromose name and the corresponding locus per row for each de novo mutation. <br />



#### The output format of HAPDeNovo:
```
Chr	   Locus	   child_GT	  parents1_GT	 parents2_GT	Confidence
chr15	21173525	0|1	      0|0	         0|0	         H
chr15	22659065	0|1	      0|0	         0|0	         L
chr15	23573074	0/1	      0|0	         0|0	         L
chr15	25609792	0/1	      0|0	         0|0	         L
chr15	25841367	0/1	      0|0	         0|0	         L
chr15	26977166	0/1	      0|0	         0|0	         L
chr15	27700996	0/1	      0|0	         0|0	         L
chr15	28094057	0/1	      0|0	         0|0	         L
chr15	32590720	1|0	      0|0	         0|0	         L
chr15	33183990	0|1	      0|0	         0|0	         H
chr15	50953965	1|0	      0|0	         0|0	         H
chr15	51248561	0|1	      0|0                0|0	         H
chr15	52560491	0/1	      0|0	         0|0	         L
chr15	58149075	1|0	      0|0	         0|0	         H
chr15	58669774	0|1	      0|0	         0|0	         H
chr15	60813433	0/1	      0|0	         0|0	         L
chr15	63727259	0/1	      0|0	         0|0	         L
chr15	64217272	0/1	      0|0	         0|0	         L
chr15	70904630	0/1	      0|0	         0|0	         L
chr15	74327590	0/1	      0|0	         0|0	         L
chr15	74880589	1|0	      0|0	         0|0	         H
chr15	76481707	0/1	      0|0	         0|0	         L
chr15	80743984	0/1	      0|0	         0|0	         L
chr15	83299364	0|1	      0|0	         0|0	         L    
chr15	83299956	0|1	      0|0	         0|0	         L
chr15	83305550	0|1	      0|0	         0|0	         L
chr15	83307063	0|1	      0|0	         0|0	         L
chr15	83319622	0|1	      0|0	         0|0	         L
chr15	83323255	0|1	      0|0	         0|0	         L
chr15	83336872	0|1	      0|0	         0|0	         L
chr15	83358339	0|1	      0|0	         0|0	         L
chr15	83361080	0|1	      0|0	         0|0	         L
chr15	83386567	0|1	      0|0	         0|0	         L
chr15	83389209	0|1	      0|0	         0|0	         H
chr15	83450721	0|1	      0|0	         0|0             L
chr15	83457052	0|1	      0|0	         0|0	         L
chr15	85056658	1|0	      0|0	         0|0	         L
chr15	85715561	0|1	      0|0	         0|0	         H
chr15	87791919	1|0	      0|0	         0|0	         H
chr15	98887977	0/1	      0|0	         0|0	         L
chr15	99175976	0|1	      0|0	         0|0	         H
chr15	100078310	0/1	      0|0	         0|0	         L
chr15	100884734	0/1	      0|0	         0|0	         L
```

